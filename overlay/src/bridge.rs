//! Lua <-> overlay bridge over two named pipes, one line of JSON each way.
//!
//! Lua cannot call into this DLL (UE4SS does not export the Lua C API), but
//! its `io.open` can open a named pipe like a file. So Lua drives the
//! exchange from the game thread on a timer:
//!
//!   Lua  → `\\.\pipe\mt_overlay_up`   : `{"state":{..}|null,"events":[..]}\n`
//!   Rust → `\\.\pipe\mt_overlay_down` : `{"visible":bool,"commands":[..]}\n`
//!
//! Every request gets exactly one immediate reply, so Lua's blocking read
//! returns at once. If this thread dies its handles close and Lua's read sees
//! EOF instead of hanging the game thread.

use std::fs::File;
use std::io::{BufRead, BufReader, Write};
use std::os::windows::io::FromRawHandle;

use std::sync::Mutex;

use serde::{Deserialize, Serialize};
use windows_sys::Win32::Foundation::{
    CloseHandle, GetLastError, ERROR_PIPE_CONNECTED, HANDLE, INVALID_HANDLE_VALUE,
};
use windows_sys::Win32::Storage::FileSystem::{PIPE_ACCESS_INBOUND, PIPE_ACCESS_OUTBOUND};
use windows_sys::Win32::System::Pipes::{
    ConnectNamedPipe, CreateNamedPipeW, PIPE_READMODE_BYTE, PIPE_TYPE_BYTE, PIPE_WAIT,
};

use crate::log;

const PIPE_UP: &str = r"\\.\pipe\mt_overlay_up";
const PIPE_DOWN: &str = r"\\.\pipe\mt_overlay_down";

/// Admin-only RaceCam snapshot. Never sent by player builds or by an older
/// Lua mod, which is why GameState's field defaults to `None`. Gated with the
/// feature so `--no-default-features` compiles with zero dead-code warnings.
#[cfg(feature = "admin")]
#[derive(Debug, Clone, Default, Deserialize)]
#[serde(default)]
pub struct RaceCamStatus {
    pub armed: bool,
    pub plan_id: String,
    pub current_event: Option<String>,
    pub port: u16,
}

/// Lua sends plain strings for the existing toggles, and a small object for
/// URL launches. `#[serde(untagged)]` keeps both shapes in one array; the
/// object variant defaults its fields so an unknown/malformed event cannot
/// break the whole bridge request.
#[derive(Deserialize)]
#[serde(untagged)]
enum Event {
    Named(String),
    Detail {
        #[serde(default)]
        kind: String,
        #[serde(default)]
        url: String,
    },
}

// `ShellExecuteW` lives in shell32, which is not behind a feature of any
// Win32 crate currently in Cargo.toml. Declaring it here keeps the launcher
// self-contained and avoids an extra dependency feature just for one call.
#[link(name = "shell32")]
extern "system" {
    fn ShellExecuteW(
        hwnd: HANDLE,
        operation: *const u16,
        file: *const u16,
        parameters: *const u16,
        directory: *const u16,
        show_cmd: i32,
    ) -> HANDLE;
}

/// Open a loopback URL in the default Windows browser. The URL carries a
/// `#token=` fragment: it must never be written to the log, and must never
/// escape to a remote host. `ShellExecuteW` is used deliberately — no
/// `cmd /c start`, so no shell parsing of an attacker-influenced string.
fn open_url(url: &str) {
    if !url.starts_with("http://127.0.0.1:") || url.contains('\0') {
        log::warn("bridge: refused open_url (not a loopback URL)");
        return;
    }
    let file: Vec<u16> = url.encode_utf16().chain(Some(0)).collect();
    let open: Vec<u16> = "open".encode_utf16().chain(Some(0)).collect();
    // 1 == SW_SHOWNORMAL. > 32 means the shell accepted the request.
    let result = unsafe {
        ShellExecuteW(
            std::ptr::null_mut(),
            open.as_ptr(),
            file.as_ptr(),
            std::ptr::null(),
            std::ptr::null(),
            1,
        )
    };
    if result as isize <= 32 {
        log::warn("bridge: ShellExecuteW failed for open_url");
    }
}

/// Snapshot of the Lua-side settings, pushed up on every poll.
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
    /// `None` when Lua skipped the aim trace this poll (it traces every ~500 ms).
    #[cfg(feature = "admin")]
    pub aimed_mass_kg: Option<f64>,
    /// `None` on player builds, when RaceCam is not loaded, or when an older
    /// Lua mod predates the field.
    #[cfg(feature = "admin")]
    #[serde(default)]
    pub racecam: Option<RaceCamStatus>,
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
    /// "despawn" | "impulse" | "door" | "engine" — runs on the aimed actor.
    /// Admin overlay also sends "racecam_open", "racecam_load_event" and
    /// "racecam_stop" through this same string channel.
    #[cfg(feature = "admin")]
    Trigger(String),
    /// Teleport point name; Lua sends `/tp <name>` through chat.
    Teleport(String),
    /// Chat emote command, e.g. "/Wave".
    Emote(String),
}

#[derive(Deserialize)]
struct Request {
    state: Option<GameState>,
    #[serde(default)]
    events: Vec<Event>,
    /// TeleportManager's point names, sent once per connection.
    teleport_points: Option<Vec<String>>,
}

#[derive(Serialize)]
struct Response {
    visible: bool,
    commands: Vec<Command>,
    /// Admin only: sorted `.json` filenames currently in the RaceCam inbox.
    /// `None` on player builds and on polls that did not rescan (the directory
    /// is only read once every ~2 s so pipe traffic stays tiny).
    #[cfg(feature = "admin")]
    #[serde(skip_serializing_if = "Option::is_none")]
    inbox_files: Option<Vec<String>>,
}

/// Admin only: list the `.json` files an operator dropped into the RaceCam
/// inbox. Runs on this background bridge thread (never the game thread), uses
/// plain `std::fs::read_dir` (no `cmd.exe` / console flash), and never panics
/// when the folder is missing. Names must match ASCII `[A-Za-z0-9._-]+\.json`
/// so a `GET /api/inbox_file` can never be pointed outside the inbox.
#[cfg(feature = "admin")]
fn valid_inbox_json_name(name: &str) -> bool {
    let stem_len = name.len().saturating_sub(".json".len());
    stem_len > 0
        && name.ends_with(".json")
        && name
            .bytes()
            .all(|b| b.is_ascii_alphanumeric() || b == b'.' || b == b'_' || b == b'-')
}

#[cfg(feature = "admin")]
fn scan_inbox_files() -> Vec<String> {
    const REL: &str = "ue4ss/Mods/MotorTownClientMod/racecam/inbox";

    // The DLL lives next to the game .exe, so current_exe()'s directory is the
    // game's Binaries/Win64. Fall back to the same path relative to the cwd
    // (e.g. a dev harness) when the exe path cannot be resolved or has no
    // inbox yet.
    let mut dir = std::env::current_exe()
        .ok()
        .and_then(|exe| exe.parent().map(|parent| parent.join(REL)))
        .unwrap_or_else(|| std::path::PathBuf::from(REL));
    if !dir.is_dir() {
        dir = std::path::PathBuf::from(REL);
    }

    let mut names = Vec::new();
    if let Ok(entries) = std::fs::read_dir(&dir) {
        for entry in entries.flatten() {
            let os_name = entry.file_name();
            let name = os_name.to_string_lossy();
            if valid_inbox_json_name(&name) {
                names.push(name.into_owned());
            }
        }
    }
    names.sort();
    names.dedup();
    names.truncate(100);
    names
}

#[derive(Default)]
pub struct Shared {
    pub state: GameState,
    pub connected: bool,
    pending: Vec<Command>,
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
        #[cfg(feature = "admin")]
        racecam: None,
    },
    connected: false,
    pending: Vec::new(),
});

/// Queue a command for the next Lua poll.
pub fn send(cmd: Command) {
    if let Ok(mut s) = SHARED.lock() {
        s.pending.push(cmd);
    }
}

pub fn start() {
    std::thread::spawn(|| loop {
        if let Err(e) = serve_one_client() {
            log::warn(&format!("bridge: {e}"));
        }
        if let Ok(mut s) = SHARED.lock() {
            s.connected = false;
        }
        // Lua reconnects after a mod hot-reload; be ready for it.
        std::thread::sleep(std::time::Duration::from_millis(500));
    });
}

fn create_pipe(name: &str, access: u32) -> std::io::Result<HANDLE> {
    let wide: Vec<u16> = name.encode_utf16().chain(Some(0)).collect();
    let h = unsafe {
        CreateNamedPipeW(
            wide.as_ptr(),
            access,
            PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
            1,
            64 * 1024,
            64 * 1024,
            0,
            std::ptr::null(),
        )
    };
    if h == INVALID_HANDLE_VALUE {
        return Err(std::io::Error::last_os_error());
    }
    Ok(h)
}

fn connect(h: HANDLE) -> std::io::Result<()> {
    let ok = unsafe { ConnectNamedPipe(h, std::ptr::null_mut()) };
    // The client opening before we call Connect is success, not an error.
    if ok == 0 && unsafe { GetLastError() } != ERROR_PIPE_CONNECTED {
        let err = std::io::Error::last_os_error();
        unsafe { CloseHandle(h) };
        return Err(err);
    }
    Ok(())
}

fn serve_one_client() -> std::io::Result<()> {
    // Create both ends before waiting on either, so Lua can open them in order.
    let up = create_pipe(PIPE_UP, PIPE_ACCESS_INBOUND)?;
    let down = match create_pipe(PIPE_DOWN, PIPE_ACCESS_OUTBOUND) {
        Ok(h) => h,
        Err(e) => {
            unsafe { CloseHandle(up) };
            return Err(e);
        }
    };
    connect(up)?;
    connect(down)?;
    // From here the Files own the handles and close them on drop.
    let mut reader = BufReader::new(unsafe { File::from_raw_handle(up as _) });
    let mut writer = unsafe { File::from_raw_handle(down as _) };
    log::info("bridge: Lua connected");
    if let Ok(mut s) = SHARED.lock() {
        s.connected = true;
    }

    // Inbox scan is throttled on this background thread: read the directory at
    // most once every 2 s and only put the file list on the pipe when we have
    // something new (i.e. on each scan). Initialised stale so the very first
    // response carries the current list to a freshly connected Lua mod.
    #[cfg(feature = "admin")]
    let mut last_inbox_scan = std::time::Instant::now()
        .checked_sub(std::time::Duration::from_secs(2))
        .unwrap_or_else(std::time::Instant::now);

    let mut line = String::new();
    loop {
        line.clear();
        if reader.read_line(&mut line)? == 0 {
            log::info("bridge: Lua disconnected");
            return Ok(());
        }

        let commands = match serde_json::from_str::<Request>(line.trim()) {
            Ok(req) => {
                for ev in &req.events {
                    match ev {
                        Event::Named(kind) => match kind.as_str() {
                            #[cfg(feature = "admin")]
                            "toggle" => crate::toggle(&crate::ADMIN_OPEN, "admin panel"),
                            "toggle_teleport" => crate::toggle(&crate::TELEPORT_OPEN, "teleport menu"),
                            _ => log::warn(&format!("bridge: unknown event {kind}")),
                        },
                        Event::Detail { kind, url } => {
                            if kind.as_str() == "open_url" {
                                // open_url never logs `url`: it holds a #token=.
                                open_url(url);
                            } else {
                                log::warn(&format!("bridge: unknown event {kind}"));
                            }
                        }
                    }
                }
                if let Some(points) = req.teleport_points {
                    crate::teleports::set_fallback(points);
                }
                let mut s = SHARED.lock().unwrap_or_else(|p| p.into_inner());
                #[cfg(feature = "admin")]
                if let Some(mut state) = req.state {
                    if state.aimed_mass_kg.is_none() {
                        state.aimed_mass_kg = s.state.aimed_mass_kg;
                    }
                    s.state = state;
                }
                #[cfg(not(feature = "admin"))]
                if let Some(state) = req.state {
                    s.state = state;
                }
                std::mem::take(&mut s.pending)
            }
            Err(e) => {
                log::warn(&format!("bridge: bad request ({e}): {}", line.trim()));
                Vec::new()
            }
        };

        // Rescan at most once every ~2 s. Only a scan poll carries the list,
        // so the 50 ms Lua poll cadence does not flood the pipe with JSON.
        #[cfg(feature = "admin")]
        let inbox_files_now = {
            let now = std::time::Instant::now();
            if now
                .checked_duration_since(last_inbox_scan)
                .map_or(false, |elapsed| elapsed >= std::time::Duration::from_secs(2))
            {
                last_inbox_scan = now;
                Some(scan_inbox_files())
            } else {
                None
            }
        };

        // Always reply, even to a bad request: Lua is blocked on this line.
        let resp = Response {
            visible: crate::any_open(),
            commands,
            #[cfg(feature = "admin")]
            inbox_files: inbox_files_now,
        };
        let mut out = serde_json::to_string(&resp).unwrap_or_else(|_| "{}".into());
        out.push('\n');
        writer.write_all(out.as_bytes())?;
        writer.flush()?;
    }
}
