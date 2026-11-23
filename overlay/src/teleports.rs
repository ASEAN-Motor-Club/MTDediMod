//! Teleport point list for the Tab menu.
//!
//! Fetched from the server API here rather than in Lua: the Lua version
//! needed the native `fetch` module, which was pulled out of the load while
//! bisecting a crash. If the API is unreachable we fall back to the names
//! Lua sends from TeleportManager.

use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Mutex;
use std::time::Duration;

use serde::Deserialize;

use crate::log;

const API_URL: &str = "https://server.aseanmotorclub.com/api/v1/teleports/";

#[derive(Clone)]
pub enum Points {
    Loading,
    Loaded(Vec<String>),
    /// API failed; use Lua's list (may still be empty if Lua has not sent it).
    Failed(String),
}

static STARTED: AtomicBool = AtomicBool::new(false);
static API: Mutex<Points> = Mutex::new(Points::Loading);
/// Names from Lua's TeleportManager (defaults or config.json override).
static FALLBACK: Mutex<Vec<String>> = Mutex::new(Vec::new());

#[derive(Deserialize)]
struct Item {
    name: String,
}

/// Start the API fetch the first time the menu opens.
pub fn ensure_fetched() {
    if STARTED.swap(true, Ordering::SeqCst) {
        return;
    }
    std::thread::spawn(|| {
        let result = ureq::get(API_URL)
            .timeout(Duration::from_secs(8))
            .call()
            .map_err(|e| e.to_string())
            .and_then(|r| r.into_string().map_err(|e| e.to_string()))
            .and_then(|body| serde_json::from_str::<Vec<Item>>(&body).map_err(|e| e.to_string()));
        let state = match result {
            Ok(items) if !items.is_empty() => {
                log::info(&format!("teleports: {} points from API", items.len()));
                Points::Loaded(items.into_iter().map(|i| i.name).collect())
            }
            Ok(_) => Points::Failed("API returned no points".into()),
            Err(e) => {
                log::warn(&format!("teleports: API fetch failed: {e}"));
                Points::Failed(e)
            }
        };
        *API.lock().unwrap_or_else(|p| p.into_inner()) = state;
    });
}

pub fn set_fallback(names: Vec<String>) {
    *FALLBACK.lock().unwrap_or_else(|p| p.into_inner()) = names;
}

/// The list to show, and a note on where it came from when not the API.
pub fn current() -> (Vec<String>, Option<String>) {
    match API.lock().map(|p| p.clone()).unwrap_or(Points::Loading) {
        Points::Loaded(names) => (names, None),
        Points::Loading => (Vec::new(), Some("Loading teleports...".into())),
        Points::Failed(why) => {
            let names = FALLBACK.lock().map(|f| f.clone()).unwrap_or_default();
            let why: String = why.chars().take(60).collect();
            (names, Some(format!("Server list unavailable ({why}); built-in points")))
        }
    }
}
