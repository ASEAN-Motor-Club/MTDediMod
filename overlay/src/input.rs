//! Input: subclass the game window's WndProc, translate messages into egui
//! events, and swallow the ones egui is using.
//!
//! This is the fix for the old panel's biggest problem: UE4SS keybinds are
//! passive listeners, so Ctrl+Shift+F10 and every click on the UMG panel also
//! reached the game. A WndProc that returns without calling the original
//! means the game never sees the message.

use std::sync::atomic::{AtomicBool, AtomicIsize, Ordering};
use std::sync::{Mutex, OnceLock};
use std::time::Instant;

use egui::{Event, Key, Modifiers, MouseWheelUnit, PointerButton, Pos2, RawInput, Rect, Vec2};
use windows::Win32::Foundation::{HWND, LPARAM, LRESULT, RECT, WPARAM};
use windows::Win32::UI::Input::KeyboardAndMouse::*;
use windows::Win32::UI::WindowsAndMessaging::*;

use crate::log;

// Lives in the Controls metadata in windows-rs; not worth the feature.
const WM_MOUSELEAVE: u32 = 0x02A3;

static ORIG_WNDPROC: AtomicIsize = AtomicIsize::new(0);
static HWND_RAW: AtomicIsize = AtomicIsize::new(0);
/// egui is mid-interaction (dragging a value, holding a button).
static WANTS_POINTER: AtomicBool = AtomicBool::new(false);
/// The pointer was over the panel last frame.
static HOVERED: AtomicBool = AtomicBool::new(false);
static WANTS_KEYBOARD: AtomicBool = AtomicBool::new(false);
/// Set when the hotkey's key-down was eaten, so its key-up is eaten too.
static EAT_HOTKEY_UP: AtomicBool = AtomicBool::new(false);

/// Events in window client coordinates; mapped to back-buffer pixels when
/// handed to egui, since the game may render at a different size.
enum Pending {
    Move(f32, f32),
    Button(f32, f32, PointerButton, bool),
    Wheel(f32),
    Text(String),
    Key(Key, bool),
    Gone,
}

static QUEUE: Mutex<Vec<Pending>> = Mutex::new(Vec::new());
static START: OnceLock<Instant> = OnceLock::new();

pub fn install(hwnd: HWND) {
    if HWND_RAW.load(Ordering::SeqCst) == hwnd.0 as isize {
        return;
    }
    unsafe {
        let prev = SetWindowLongPtrW(hwnd, GWLP_WNDPROC, wndproc as *const () as isize);
        if prev == 0 {
            log::error("SetWindowLongPtrW(GWLP_WNDPROC) failed; no input");
            return;
        }
        ORIG_WNDPROC.store(prev, Ordering::SeqCst);
    }
    HWND_RAW.store(hwnd.0 as isize, Ordering::SeqCst);
    log::info("WndProc subclassed");
}

/// The open windows' last drawn rects, in back-buffer pixels, plus the
/// back-buffer size. Lets the WndProc swallow a click by position even when
/// egui has not yet seen the pointer over a window (move + click in the same
/// frame).
static PANELS: Mutex<(Vec<Rect>, f32, f32)> = Mutex::new((Vec::new(), 0.0, 0.0));

pub fn set_wants_input(
    pointer: bool,
    hovered: bool,
    keyboard: bool,
    panels_px: Vec<Rect>,
    width: f32,
    height: f32,
) {
    WANTS_POINTER.store(pointer, Ordering::Relaxed);
    HOVERED.store(hovered, Ordering::Relaxed);
    WANTS_KEYBOARD.store(keyboard, Ordering::Relaxed);
    if let Ok(mut p) = PANELS.lock() {
        *p = (panels_px, width, height);
    }
}

/// Is client-space point (x, y) over one of our windows?
fn over_panel(x: f32, y: f32) -> bool {
    let Ok(panels) = PANELS.lock() else {
        return false;
    };
    let (rects, width, height) = &*panels;
    let hwnd = HWND(HWND_RAW.load(Ordering::Relaxed) as _);
    let mut client = RECT::default();
    if unsafe { GetClientRect(hwnd, &mut client) }.is_err() || client.right <= 0 || client.bottom <= 0 {
        return false;
    }
    let px = Pos2::new(x * width / client.right as f32, y * height / client.bottom as f32);
    rects.iter().any(|r| r.contains(px))
}

fn modifiers() -> Modifiers {
    let down = |vk: VIRTUAL_KEY| unsafe { GetKeyState(vk.0 as i32) } < 0;
    let ctrl = down(VK_CONTROL);
    Modifiers {
        alt: down(VK_MENU),
        ctrl,
        shift: down(VK_SHIFT),
        mac_cmd: false,
        command: ctrl,
    }
}

/// Drain queued input into a RawInput for a `width` x `height` back buffer.
pub fn take_raw_input(width: f32, height: f32) -> RawInput {
    let hwnd = HWND(HWND_RAW.load(Ordering::Relaxed) as _);
    let mut client = RECT::default();
    let (sx, sy) = if unsafe { GetClientRect(hwnd, &mut client) }.is_ok()
        && client.right > 0
        && client.bottom > 0
    {
        (width / client.right as f32, height / client.bottom as f32)
    } else {
        (1.0, 1.0)
    };
    let pos = |x: f32, y: f32| Pos2::new(x * sx, y * sy);
    let mods = modifiers();

    let pending = std::mem::take(&mut *QUEUE.lock().unwrap_or_else(|p| p.into_inner()));
    let events = pending
        .into_iter()
        .map(|p| match p {
            Pending::Move(x, y) => Event::PointerMoved(pos(x, y)),
            Pending::Button(x, y, button, pressed) => Event::PointerButton {
                pos: pos(x, y),
                button,
                pressed,
                modifiers: mods,
            },
            Pending::Wheel(lines) => Event::MouseWheel {
                unit: MouseWheelUnit::Line,
                delta: Vec2::new(0.0, lines),
                modifiers: mods,
            },
            Pending::Text(t) => Event::Text(t),
            Pending::Key(key, pressed) => Event::Key {
                key,
                physical_key: None,
                pressed,
                repeat: false,
                modifiers: mods,
            },
            Pending::Gone => Event::PointerGone,
        })
        .collect();

    RawInput {
        screen_rect: Some(Rect::from_min_size(Pos2::ZERO, Vec2::new(width, height))),
        time: Some(START.get_or_init(Instant::now).elapsed().as_secs_f64()),
        modifiers: mods,
        focused: true,
        events,
        ..Default::default()
    }
}

fn push(p: Pending) {
    if let Ok(mut q) = QUEUE.lock() {
        // Present stops draining while the game is minimised; cap the backlog.
        if q.len() < 512 {
            q.push(p);
        }
    }
}

fn lparam_xy(lparam: LPARAM) -> (f32, f32) {
    let x = (lparam.0 & 0xffff) as i16 as f32;
    let y = ((lparam.0 >> 16) & 0xffff) as i16 as f32;
    (x, y)
}

fn map_key(vk: VIRTUAL_KEY) -> Option<Key> {
    Some(match vk {
        VK_BACK => Key::Backspace,
        VK_TAB => Key::Tab,
        VK_RETURN => Key::Enter,
        VK_ESCAPE => Key::Escape,
        VK_DELETE => Key::Delete,
        VK_HOME => Key::Home,
        VK_END => Key::End,
        VK_LEFT => Key::ArrowLeft,
        VK_RIGHT => Key::ArrowRight,
        VK_UP => Key::ArrowUp,
        VK_DOWN => Key::ArrowDown,
        VK_A => Key::A,
        VK_C => Key::C,
        VK_V => Key::V,
        VK_X => Key::X,
        VK_Z => Key::Z,
        _ => return None,
    })
}

#[cfg(feature = "admin")]
fn is_hotkey(vk: VIRTUAL_KEY) -> bool {
    let m = modifiers();
    vk == VK_F10 && m.ctrl && m.shift
}

unsafe extern "system" fn wndproc(hwnd: HWND, msg: u32, wparam: WPARAM, lparam: LPARAM) -> LRESULT {
    let handled = std::panic::catch_unwind(|| handle(msg, wparam, lparam)).unwrap_or(false);
    if handled {
        return LRESULT(0);
    }
    let orig: WNDPROC = std::mem::transmute(ORIG_WNDPROC.load(Ordering::Relaxed));
    CallWindowProcW(orig, hwnd, msg, wparam, lparam)
}

/// Returns true when the message is consumed and must not reach the game.
fn handle(msg: u32, wparam: WPARAM, lparam: LPARAM) -> bool {
    let vk = VIRTUAL_KEY(wparam.0 as u16);
    let repeat = lparam.0 & (1 << 30) != 0;
    let keyboard = WANTS_KEYBOARD.load(Ordering::Relaxed);

    // Window toggles work whether or not anything is open. F10 arrives as a
    // *system* key (it activates the menu bar), so check both message kinds.
    match msg {
        #[cfg(feature = "admin")]
        WM_KEYDOWN | WM_SYSKEYDOWN if is_hotkey(vk) => {
            if !repeat {
                crate::toggle(&crate::ADMIN_OPEN, "admin panel");
            }
            EAT_HOTKEY_UP.store(true, Ordering::Relaxed);
            return true;
        }
        #[cfg(feature = "admin")]
        WM_KEYUP | WM_SYSKEYUP if vk == VK_F10 && EAT_HOTKEY_UP.swap(false, Ordering::Relaxed) => {
            return true;
        }
        // Plain Tab toggles the teleport menu. It still reaches the game, as
        // it did with the UMG widget, so the game's own Tab binding is kept.
        // While typing in one of our fields Tab is egui's, not a toggle.
        WM_KEYDOWN if vk == VK_TAB && !repeat && !keyboard => {
            let m = modifiers();
            if !(m.ctrl || m.shift || m.alt) {
                crate::toggle(&crate::TELEPORT_OPEN, "teleport menu");
            }
            return false;
        }
        // Esc closes our windows and does not open the game's pause menu.
        // While typing it is egui's (leaves the field) and falls through.
        WM_KEYDOWN if vk == VK_ESCAPE && !keyboard && crate::any_open() => {
            #[cfg(feature = "admin")]
            crate::set_open(&crate::ADMIN_OPEN, "admin panel", false);
            crate::set_open(&crate::TELEPORT_OPEN, "teleport menu", false);
            EAT_HOTKEY_UP.store(true, Ordering::Relaxed);
            return true;
        }
        WM_KEYUP if vk == VK_ESCAPE && EAT_HOTKEY_UP.swap(false, Ordering::Relaxed) => {
            return true;
        }
        _ => {}
    }

    if !crate::any_open() {
        return false;
    }
    let pointer = WANTS_POINTER.load(Ordering::Relaxed);
    let hovered = HOVERED.load(Ordering::Relaxed);

    match msg {
        WM_MOUSEMOVE => {
            let (x, y) = lparam_xy(lparam);
            push(Pending::Move(x, y));
            false // the game still tracks the cursor
        }
        WM_MOUSELEAVE => {
            push(Pending::Gone);
            false
        }
        WM_LBUTTONDOWN | WM_LBUTTONUP | WM_RBUTTONDOWN | WM_RBUTTONUP | WM_MBUTTONDOWN
        | WM_MBUTTONUP | WM_LBUTTONDBLCLK | WM_RBUTTONDBLCLK => {
            let (x, y) = lparam_xy(lparam);
            let (button, pressed) = match msg {
                WM_LBUTTONDOWN | WM_LBUTTONDBLCLK => (PointerButton::Primary, true),
                WM_LBUTTONUP => (PointerButton::Primary, false),
                WM_RBUTTONDOWN | WM_RBUTTONDBLCLK => (PointerButton::Secondary, true),
                WM_RBUTTONUP => (PointerButton::Secondary, false),
                WM_MBUTTONDOWN => (PointerButton::Middle, true),
                _ => (PointerButton::Middle, false),
            };
            push(Pending::Button(x, y, button, pressed));
            // Decide by this click's own position: last frame's hover state
            // can be stale when the move and the click arrive together.
            // Always let button-ups through so the game never sees a stuck button.
            pressed && (pointer || over_panel(x, y))
        }
        WM_MOUSEWHEEL => {
            let delta = ((wparam.0 >> 16) & 0xffff) as i16 as f32 / WHEEL_DELTA as f32;
            push(Pending::Wheel(delta));
            pointer || hovered
        }
        // UE reads mouse look and clicks from raw input, not WM_*BUTTON*.
        // DefWindowProc must still run for WM_INPUT, so pass it to the
        // default handler instead of the game's.
        WM_INPUT if pointer || hovered => {
            unsafe {
                let hwnd = HWND(HWND_RAW.load(Ordering::Relaxed) as _);
                DefWindowProcW(hwnd, msg, wparam, lparam);
            }
            true
        }
        WM_KEYDOWN | WM_SYSKEYDOWN | WM_KEYUP | WM_SYSKEYUP => {
            let pressed = msg == WM_KEYDOWN || msg == WM_SYSKEYDOWN;
            if let Some(key) = map_key(vk) {
                push(Pending::Key(key, pressed));
            }
            keyboard && pressed
        }
        WM_CHAR => {
            if let Some(c) = char::from_u32(wparam.0 as u32) {
                if !c.is_control() {
                    push(Pending::Text(c.to_string()));
                }
            }
            keyboard
        }
        _ => false,
    }
}
