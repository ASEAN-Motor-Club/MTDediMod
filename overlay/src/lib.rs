//! mt_overlay — egui panels for MotorTownClientMod.
//!
//! Replaces the UMG widgets (AdminPanel.lua, TeleportWidget.lua,
//! EmoteWidget.lua: StaticConstructObject trees + IsPressed polls) with
//! immediate-mode egui windows drawn on top of the game's swapchain.
//!
//! Split of responsibilities:
//! - Rust (this crate): rendering, input (and *consuming* it — the thing
//!   UE4SS keybinds cannot do), window layout, the teleport list fetch.
//! - Lua (OverlayBridge.lua): everything that touches UObjects. It polls the
//!   bridge pipe from the game thread, pushes state up, applies commands down.
//!
//! Load order: Lua calls `package.loadlib(dll, "*")` → DllMain → init thread
//! → bridge pipe server + DXGI hooks. Nothing here calls into UE directly.

mod bridge;
mod hook;
mod input;
mod layout;
mod log;
mod painter;
mod teleports;
mod ui;

use std::ffi::c_void;
use std::sync::atomic::{AtomicBool, Ordering};

use windows::Win32::Foundation::{BOOL, HMODULE, TRUE};
use windows::Win32::System::SystemServices::DLL_PROCESS_ATTACH;

/// Admin panel open (Ctrl+Shift+F10 / console `adminpanel`).
/// Compiled out of the player build by the `admin` feature.
#[cfg(feature = "admin")]
pub(crate) static ADMIN_OPEN: AtomicBool = AtomicBool::new(false);
/// Teleport + emote menu open (Tab / console `tpmenu`).
pub(crate) static TELEPORT_OPEN: AtomicBool = AtomicBool::new(false);

/// Any window showing: we draw, Lua shows the mouse cursor.
pub(crate) fn any_open() -> bool {
    #[cfg(feature = "admin")]
    if ADMIN_OPEN.load(Ordering::Relaxed) {
        return true;
    }
    TELEPORT_OPEN.load(Ordering::Relaxed)
}

pub(crate) fn toggle(flag: &AtomicBool, name: &str) {
    set_open(flag, name, !flag.load(Ordering::Relaxed));
}

pub(crate) fn set_open(flag: &AtomicBool, name: &str, open: bool) {
    if flag.swap(open, Ordering::Relaxed) != open {
        log::info(&format!("{name} {}", if open { "shown" } else { "hidden" }));
        if open && std::ptr::eq(flag, &TELEPORT_OPEN) {
            teleports::ensure_fetched();
        }
    }
}

#[no_mangle]
#[allow(non_snake_case)]
extern "system" fn DllMain(module: HMODULE, reason: u32, _reserved: *mut c_void) -> BOOL {
    if reason == DLL_PROCESS_ATTACH {
        log::init(module);
        // DllMain holds the loader lock: do no real work here. A thread
        // started now runs once the lock is released.
        std::thread::spawn(|| {
            log::info(concat!("mt_overlay ", env!("CARGO_PKG_VERSION"), " loaded"));
            bridge::start();
            if let Err(e) = unsafe { hook::install() } {
                log::error(&format!("hook install failed: {e}"));
            }
        });
    }
    TRUE
}
