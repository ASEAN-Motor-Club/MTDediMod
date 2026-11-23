//! Where the user dragged each window, saved to `mt_overlay_layout.json` next
//! to the DLL so the panels come back in the same place next session.

use std::collections::BTreeMap;
use std::sync::Mutex;

use crate::log;

const FILE: &str = "mt_overlay_layout.json";

static POSITIONS: Mutex<Option<BTreeMap<String, [f32; 2]>>> = Mutex::new(None);

fn with<R>(f: impl FnOnce(&mut BTreeMap<String, [f32; 2]>) -> R) -> R {
    let mut guard = POSITIONS.lock().unwrap_or_else(|p| p.into_inner());
    let map = guard.get_or_insert_with(|| {
        std::fs::read_to_string(log::beside_dll(FILE))
            .ok()
            .and_then(|s| serde_json::from_str(&s).ok())
            .unwrap_or_default()
    });
    f(map)
}

/// Saved top-left of window `key`, in points.
pub fn get(key: &str) -> Option<egui::Pos2> {
    with(|m| m.get(key).map(|p| egui::pos2(p[0], p[1])))
}

/// Record a window position; writes the file only when it actually moved.
pub fn set(key: &str, pos: egui::Pos2) {
    let changed = with(|m| {
        let new = [pos.x.round(), pos.y.round()];
        if m.get(key) == Some(&new) {
            return None;
        }
        m.insert(key.to_owned(), new);
        serde_json::to_string_pretty(m).ok()
    });
    if let Some(json) = changed {
        if let Err(e) = std::fs::write(log::beside_dll(FILE), json) {
            log::warn(&format!("layout save failed: {e}"));
        }
    }
}
