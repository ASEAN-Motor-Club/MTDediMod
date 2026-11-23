//! The overlay's windows. Same controls as the UMG widgets they replace
//! (AdminPanel.lua, TeleportWidget.lua + EmoteWidget.lua), but immediate-mode:
//! no widget tree to build against the HUD, no label refresh, no click
//! polling. Every action becomes a bridge Command that Lua applies.
//!
//! Every window can be dragged by its title bar; positions are saved by
//! `layout` and restored next session.

use std::sync::atomic::{AtomicBool, Ordering};

use egui::{Align2, Color32, RichText};

use crate::bridge::{self, Command, GameState};
use crate::{layout, teleports};

const TITLE: Color32 = Color32::from_rgb(0, 204, 255);

const EMOTES: &[(&str, &str)] = &[
    ("Wave", "/Wave"),
    ("Wave Hands", "/WaveHands"),
    ("Chicken Dance", "/ChickenDance"),
    ("Horse Dance", "/HorseDance"),
    ("Pointing", "/Pointing"),
];

struct WindowDef {
    key: &'static str,
    flag: &'static AtomicBool,
}

#[cfg(feature = "admin")]
const ADMIN: WindowDef = WindowDef { key: "admin", flag: &crate::ADMIN_OPEN };
const TELEPORT: WindowDef = WindowDef { key: "teleport", flag: &crate::TELEPORT_OPEN };

fn window_id(def: &WindowDef) -> egui::Id {
    egui::Id::new(("mt_overlay", def.key))
}

#[derive(Default)]
pub struct Panels {
    teleport_filter: String,
    /// Window keys being dragged; saved to the layout when the drag ends.
    dragging: std::collections::HashSet<&'static str>,
    /// Pivot each window was first placed with. egui stores the pivot's
    /// position, so the pivot must not change for the session or the window
    /// jumps (e.g. right-centre point reread as top-left after a save).
    pivots: std::collections::HashMap<&'static str, Align2>,
    /// Frames each window has been shown this session (capped).
    frames: std::collections::HashMap<&'static str, u8>,
}

/// Queue the command for Lua and apply it to our copy of the state at once,
/// so the panel does not show the old value until the next poll (~50 ms).
fn apply(cmd: Command) {
    #[cfg(feature = "admin")]
    if let Ok(mut s) = bridge::SHARED.lock() {
        let st = &mut s.state;
        match &cmd {
            #[cfg(feature = "admin")]
            Command::SetImpulseMode(v) => st.impulse_mode = v.clone(),
            #[cfg(feature = "admin")]
            Command::SetImpulseStrength(v) => st.impulse_strength = *v,
            #[cfg(feature = "admin")]
            Command::SetSpeedKmh(v) => st.speed_kmh = *v,
            #[cfg(feature = "admin")]
            Command::SetDirection(v) => st.direction = v.clone(),
            #[cfg(feature = "admin")]
            Command::SetOrigin(v) => st.origin = v.clone(),
            #[cfg(feature = "admin")]
            Command::SetRightClick(v) => st.right_click = v.clone(),
            #[cfg(feature = "admin")]
            Command::Trigger(_) => {}
            Command::Teleport(_) | Command::Emote(_) => {}
        }
    }
    #[cfg(not(feature = "admin"))]
    match &cmd {
        Command::Teleport(_) | Command::Emote(_) => {}
    }
    bridge::send(cmd);
}

/// A row of mutually exclusive options; the active one is highlighted.
#[cfg(feature = "admin")]
fn radio_row(ui: &mut egui::Ui, current: &str, options: &[&str], make: fn(String) -> Command) {
    ui.horizontal(|ui| {
        for opt in options {
            if ui.selectable_label(current == *opt, *opt).clicked() && current != *opt {
                apply(make(opt.to_string()));
            }
        }
    });
}

/// Show one movable window if its flag is set. The title-bar X clears the flag.
///
/// `default` is where it first appears, as (point, which corner of the
/// window sits on that point) — window sizes are unknown until the first
/// frame, so a right-hand window must be pinned by its right edge. A saved
/// position (top-left) wins over it.
fn movable_window(
    ctx: &egui::Context,
    panels: &mut Panels,
    def: &WindowDef,
    title: &str,
    default: (egui::Pos2, Align2),
    add_contents: impl FnOnce(&mut egui::Ui),
) {
    let mut open = def.flag.load(Ordering::Relaxed);
    if !open {
        return;
    }
    // default_pos only matters on the first frame; after that egui keeps the
    // position itself, and the pivot stays whatever it started as.
    let pivot = *panels.pivots.entry(def.key).or_insert_with(|| {
        if layout::get(def.key).is_some() { Align2::LEFT_TOP } else { default.1 }
    });
    let pos = match layout::get(def.key) {
        Some(saved) if pivot == Align2::LEFT_TOP => saved,
        _ => default.0,
    };
    // On its first frame egui does not know the window's size and keeps a
    // guessed default size on screen, which shifts a saved position. Clamp
    // to the screen only once the real size is known.
    let frames = panels.frames.entry(def.key).or_insert(0);
    *frames = frames.saturating_add(1).min(3);
    let shown = egui::Window::new(RichText::new(title).color(TITLE))
        .id(window_id(def))
        .default_pos(pos)
        .pivot(pivot)
        .constrain(*frames > 2)
        .open(&mut open)
        .resizable(false)
        .collapsible(false)
        .show(ctx, add_contents);
    if !open {
        crate::set_open(def.flag, title, false);
    }
    // Save only positions the user chose: when a drag of this window ends.
    if let Some(shown) = shown {
        if shown.response.dragged() {
            panels.dragging.insert(def.key);
        } else if panels.dragging.remove(def.key) {
            // The area rect, not shown.response.rect: the area's top-left is
            // what default_pos sets, so this restores to the same spot.
            if let Some(rect) = ctx.memory(|m| m.area_rect(window_id(def))) {
                layout::set(def.key, rect.min);
            }
        }
    }
}

impl Panels {
    pub fn show(&mut self, ctx: &egui::Context) {
        // One local state read per frame; the native bridge pushes changes
        // from Lua, so there is no 50 ms IPC poll on the game thread.
        bridge::sync_state();
        let (_state, connected): (GameState, bool) = match bridge::SHARED.lock() {
            Ok(s) => (s.state.clone(), s.connected),
            Err(_) => return,
        };
        let screen = ctx.screen_rect();

        // Defaults match the UMG widgets: admin on the right edge, vertically
        // centred; teleport centred horizontally, above the lower third.
        #[cfg(feature = "admin")]
        movable_window(
            ctx,
            self,
            &ADMIN,
            "Admin Tools",
            (egui::pos2(screen.max.x - 40.0, screen.center().y), Align2::RIGHT_CENTER),
            |ui| admin_contents(ui, &_state, connected),
        );

        let mut filter = std::mem::take(&mut self.teleport_filter);
        movable_window(
            ctx,
            self,
            &TELEPORT,
            "Teleport",
            (egui::pos2(screen.center().x, screen.max.y * 0.75), Align2::CENTER_BOTTOM),
            |ui| teleport_contents(ui, &mut filter, connected),
        );
        self.teleport_filter = filter;
    }

    /// Rects (in points) of the windows currently open, for input hit-testing.
    pub fn open_rects(&self, ctx: &egui::Context) -> Vec<egui::Rect> {
        #[cfg(feature = "admin")]
        let defs = [ADMIN, TELEPORT];
        #[cfg(not(feature = "admin"))]
        let defs = [TELEPORT];
        defs.iter()
            .filter(|d| d.flag.load(Ordering::Relaxed))
            .filter_map(|d| ctx.memory(|m| m.area_rect(window_id(d))))
            .collect()
    }
}

#[cfg(feature = "admin")]
fn admin_contents(ui: &mut egui::Ui, state: &GameState, connected: bool) {
    ui.set_width(300.0);
    if !connected {
        ui.colored_label(Color32::YELLOW, "Waiting for the Lua mod...");
        return;
    }

    match state.aimed_mass_kg {
        Some(kg) if kg > 0.0 => ui.label(format!("aimed: {kg:.0} kg")),
        _ => ui.weak("aimed: nothing with mass"),
    };
    ui.separator();

    ui.label("Impulse");
    ui.horizontal(|ui| {
        if state.impulse_mode == "speed" {
            if ui.button(" - ").clicked() {
                apply(Command::SetSpeedKmh(state.speed_kmh - 5.0));
            }
            let mut v = state.speed_kmh;
            if ui.add(egui::DragValue::new(&mut v).speed(0.5).suffix(" km/h")).changed() {
                apply(Command::SetSpeedKmh(v));
            }
            if ui.button(" + ").clicked() {
                apply(Command::SetSpeedKmh(state.speed_kmh + 5.0));
            }
        } else {
            if ui.button(" - ").clicked() {
                apply(Command::SetImpulseStrength(state.impulse_strength * 0.5));
            }
            let mut v = state.impulse_strength;
            if ui.add(egui::DragValue::new(&mut v).speed(1000.0).suffix(" raw")).changed() {
                apply(Command::SetImpulseStrength(v));
            }
            if ui.button(" + ").clicked() {
                apply(Command::SetImpulseStrength(state.impulse_strength * 2.0));
            }
        }
    });

    egui::Grid::new("impulse_opts").num_columns(2).show(ui, |ui| {
        ui.label("Mode");
        radio_row(ui, &state.impulse_mode, &["raw", "speed"], Command::SetImpulseMode);
        ui.end_row();
        ui.label("Direction");
        radio_row(ui, &state.direction, &["angled", "ray", "up"], Command::SetDirection);
        ui.end_row();
        ui.label("Origin");
        radio_row(ui, &state.origin, &["impact", "com"], Command::SetOrigin);
        ui.end_row();
    });
    ui.separator();

    ui.label("Right click does:");
    radio_row(ui, &state.right_click, &["despawn", "trunk", "engine"], Command::SetRightClick);
    ui.separator();

    ui.label("Aimed actor");
    ui.horizontal(|ui| {
        for (label, action) in [
            ("Impulse", "impulse"),
            ("Despawn", "despawn"),
            ("Door", "door"),
            ("Engine", "engine"),
        ] {
            if ui.button(label).clicked() {
                apply(Command::Trigger(action.into()));
            }
        }
    });
    ui.separator();
    ui.weak("Ctrl+Shift+F10 or Esc to close");
}

fn teleport_contents(ui: &mut egui::Ui, filter: &mut String, connected: bool) {
    if !connected {
        ui.colored_label(Color32::YELLOW, "Waiting for the Lua mod...");
        return;
    }
    let (names, note) = teleports::current();

    ui.horizontal_top(|ui| {
        ui.vertical(|ui| {
            ui.set_width(220.0);
            ui.add(
                egui::TextEdit::singleline(filter)
                    .hint_text("Search")
                    .desired_width(f32::INFINITY),
            );
            if let Some(note) = note {
                ui.weak(note);
            }
            let needle = filter.to_lowercase();
            egui::ScrollArea::vertical().max_height(320.0).show(ui, |ui| {
                for name in names.iter().filter(|n| n.to_lowercase().contains(&needle)) {
                    let button = egui::Button::new(name.as_str());
                    if ui.add_sized([ui.available_width(), 22.0], button).clicked() {
                        apply(Command::Teleport(name.clone()));
                    }
                }
            });
        });

        // Not ui.separator(): in a horizontal layout it takes all the
        // available height and stretches the window to the screen.
        ui.add_space(12.0);

        ui.vertical(|ui| {
            ui.set_width(120.0);
            ui.label("Emotes");
            for (label, cmd) in EMOTES {
                let button = egui::Button::new(*label);
                if ui.add_sized([ui.available_width(), 22.0], button).clicked() {
                    apply(Command::Emote((*cmd).into()));
                }
            }
        });
    });
    ui.separator();
    ui.weak("Tab or Esc to close");
}
