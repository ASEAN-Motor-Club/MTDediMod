//! Native bridge: Rust talks to `mt_bridge.dll` directly.
//!
//! The old implementation used two named pipes and a 50 ms Lua poll on the
//! game thread. That relay is gone. The overlay calls exported C functions:
//!
//! - `mt_bridge_submit(json, len)` — queue a command (safe from any thread).
//! - `mt_bridge_set_state(json, len)` — called by Lua through the native
//!   bridge when settings change (no timer needed).
//! - `mt_bridge_get_state(buf, cap)` — read the current state snapshot.
//!
//! The native bridge drains its queue on the game thread and invokes the Lua
//! handler registered at init. Nothing here touches UObjects, and there is no
//! polling loop on the Lua side.

use std::ffi::c_void;
use std::sync::{Mutex, OnceLock};

use serde::{Deserialize, Serialize};
use windows::core::{w, PCSTR};
use windows::Win32::Foundation::HMODULE;
use windows::Win32::System::LibraryLoader::{GetProcAddress, LoadLibraryW};

use crate::log;

type ReadyFn = unsafe extern "C" fn() -> i32;
type SubmitFn = unsafe extern "C" fn(*const u8, i32) -> i32;
type SetStateFn = unsafe extern "C" fn(*const u8, i32) -> i32;
type GetStateFn = unsafe extern "C" fn(*mut u8, i32) -> i32;

struct Bridge {
    _module: HMODULE,
    ready: ReadyFn,
    submit: SubmitFn,
    #[allow(dead_code)] // Lua pushes state; the export must still be resolved.
    set_state: SetStateFn,
    get_state: GetStateFn,
}

// Win32 module handles and plain function pointers are process-global once
// resolved; all calls go through the mutex-protected queue in C++.
unsafe impl Send for Bridge {}
unsafe impl Sync for Bridge {}

static BRIDGE: OnceLock<Option<Bridge>> = OnceLock::new();

/// Snapshot of the settings the panel displays.
#[derive(Debug, Clone, Default, Deserialize)]
#[serde(default)]
pub struct GameState {
    #[cfg(feature = "admin")]
    pub impulse_mode: String,
    #[cfg(feature = "admin")]
    pub impulse_strength: f64,
    #[cfg(feature = "admin")]
    pub speed_kmh: f64,
    #[cfg(feature = "admin")]
    pub direction: String,
    #[cfg(feature = "admin")]
    pub origin: String,
    #[cfg(feature = "admin")]
    pub right_click: String,
    #[cfg(feature = "admin")]
    pub aimed_mass_kg: Option<f64>,
    /// Teleport names pushed once by Lua; the Rust overlay fetches the server
    /// list itself and uses these as a fallback.
    #[serde(default)]
    pub teleport_points: Option<Vec<String>>,
}

/// One change for Lua to apply through the Shortcuts API.
#[derive(Debug, Clone, Serialize)]
#[serde(tag = "op", content = "value", rename_all = "snake_case")]
pub enum Command {
    #[cfg(feature = "admin")]
    SetImpulseMode(String),
    #[cfg(feature = "admin")]
    SetImpulseStrength(f64),
    #[cfg(feature = "admin")]
    SetSpeedKmh(f64),
    #[cfg(feature = "admin")]
    SetDirection(String),
    #[cfg(feature = "admin")]
    SetOrigin(String),
    #[cfg(feature = "admin")]
    SetRightClick(String),
    #[cfg(feature = "admin")]
    Trigger(String),
    Teleport(String),
    Emote(String),
}

#[derive(Default)]
pub struct Shared {
    pub state: GameState,
    pub connected: bool,
}

pub static SHARED: Mutex<Shared> = Mutex::new(Shared {
    state: GameState {
        #[cfg(feature = "admin")]
        impulse_mode: String::new(),
        #[cfg(feature = "admin")]
        impulse_strength: 0.0,
        #[cfg(feature = "admin")]
        speed_kmh: 0.0,
        #[cfg(feature = "admin")]
        direction: String::new(),
        #[cfg(feature = "admin")]
        origin: String::new(),
        #[cfg(feature = "admin")]
        right_click: String::new(),
        #[cfg(feature = "admin")]
        aimed_mass_kg: None,
        teleport_points: None,
    },
    connected: false,
});

unsafe fn symbol(module: HMODULE, name: &[u8]) -> Option<*const c_void> {
    GetProcAddress(module, PCSTR(name.as_ptr())).map(|f| f as *const c_void)
}

/// Load the native bridge. Safe to call more than once (OnceLock).
pub fn start() {
    BRIDGE.get_or_init(|| unsafe {
        let module = match LoadLibraryW(w!("mt_bridge.dll")) {
            Ok(m) => m,
            Err(e) => {
                log::warn(&format!("native bridge unavailable: {e}"));
                return None;
            }
        };
        let (Some(ready), Some(submit), Some(set_state), Some(get_state)) = (
            symbol(module, b"mt_bridge_ready\0"),
            symbol(module, b"mt_bridge_submit\0"),
            symbol(module, b"mt_bridge_set_state\0"),
            symbol(module, b"mt_bridge_get_state\0"),
        ) else {
            log::warn("native bridge is missing one or more exports");
            return None;
        };
        log::info("native bridge loaded (mt_bridge.dll)");
        Some(Bridge {
            _module: module,
            ready: std::mem::transmute::<*const c_void, ReadyFn>(ready),
            submit: std::mem::transmute::<*const c_void, SubmitFn>(submit),
            set_state: std::mem::transmute::<*const c_void, SetStateFn>(set_state),
            get_state: std::mem::transmute::<*const c_void, GetStateFn>(get_state),
        })
    });
}

fn bridge() -> Option<&'static Bridge> {
    BRIDGE.get().and_then(|b| b.as_ref())
}

/// Queue a command for the native bridge. Never blocks on the game thread.
pub fn send(cmd: Command) {
    let Some(b) = bridge() else { return };
    let Ok(json) = serde_json::to_string(&cmd) else { return };
    let code = unsafe { (b.submit)(json.as_ptr(), json.len() as i32) };
    if code != 0 {
        log::warn("native bridge rejected a command");
    }
}

/// Refresh the cached state from the native bridge. Called once per UI frame;
/// unlike the old pipe relay this is a local memory read, not IPC or a timer.
pub fn sync_state() {
    let Some(b) = bridge() else { return };
    let connected = unsafe { (b.ready)() != 0 };
    let mut buf = [0u8; 8192];
    let n = unsafe { (b.get_state)(buf.as_mut_ptr(), buf.len() as i32) };
    let mut next = None;
    if n > 0 {
        let n = (n as usize).min(buf.len());
        if let Ok(s) = serde_json::from_slice::<GameState>(&buf[..n]) {
            next = Some(s);
        }
    }
    if let Ok(mut shared) = SHARED.lock() {
        shared.connected = connected;
        if let Some(s) = next {
            if let Some(points) = s.teleport_points.as_ref() {
                if !points.is_empty() && Some(points) != shared.state.teleport_points.as_ref() {
                    crate::teleports::set_fallback(points.clone());
                }
            }
            shared.state = s;
        }
    }
}
