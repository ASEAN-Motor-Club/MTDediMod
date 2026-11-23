//! Tiny file logger: `mt_overlay.log` next to the DLL. UE4SS's console is not
//! reachable from here without the Lua C API, and stdout goes nowhere.

use std::fs::{File, OpenOptions};
use std::io::Write;
use std::path::PathBuf;
use std::sync::{Mutex, OnceLock};

use windows::Win32::Foundation::HMODULE;
use windows::Win32::System::LibraryLoader::GetModuleFileNameW;

static FILE: OnceLock<Mutex<File>> = OnceLock::new();
static DLL_PATH: OnceLock<PathBuf> = OnceLock::new();

/// Path for a file that lives next to the DLL (log, saved layout).
pub fn beside_dll(name: &str) -> PathBuf {
    DLL_PATH.get().map(|p| p.with_file_name(name)).unwrap_or_else(|| name.into())
}

pub fn init(module: HMODULE) {
    let mut buf = [0u16; 1024];
    let len = unsafe { GetModuleFileNameW(module, &mut buf) } as usize;
    let _ = DLL_PATH.set(PathBuf::from(String::from_utf16_lossy(&buf[..len])));
    let path = beside_dll("mt_overlay.log");
    if let Ok(f) = OpenOptions::new().create(true).write(true).truncate(true).open(path) {
        let _ = FILE.set(Mutex::new(f));
    }
}

fn write(level: &str, msg: &str) {
    if let Some(f) = FILE.get() {
        if let Ok(mut f) = f.lock() {
            let _ = writeln!(f, "[{level}] {msg}");
            let _ = f.flush();
        }
    }
}

pub fn info(msg: &str) {
    write("INFO", msg);
}

pub fn warn(msg: &str) {
    write("WARN", msg);
}

pub fn error(msg: &str) {
    write("ERROR", msg);
}
