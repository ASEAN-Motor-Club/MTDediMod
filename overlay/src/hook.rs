//! DXGI hooks: detour `IDXGISwapChain::Present` and `ResizeBuffers`.
//!
//! The vtable addresses come from a throwaway D3D11 device + swapchain on a
//! hidden window; the functions live in dxgi.dll and are shared by every
//! swapchain in the process, so detouring them catches the game's too.
//!
//! D3D11 only for now. UE5 defaults to D3D12; launch Motor Town with `-dx11`.
//! Under D3D12, `GetDevice::<ID3D11Device>` fails and Present passes straight
//! through (logged once).

use std::ffi::c_void;
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::sync::Mutex;

use retour::RawDetour;
use windows::core::{w, Error, Interface, Result, HRESULT};
use windows::Win32::Foundation::{E_FAIL, HINSTANCE, HMODULE, HWND, TRUE};
use windows::Win32::Graphics::Direct3D::D3D_DRIVER_TYPE_HARDWARE;
use windows::Win32::Graphics::Direct3D11::*;
use windows::Win32::Graphics::Dxgi::Common::*;
use windows::Win32::Graphics::Dxgi::*;
use windows::Win32::UI::WindowsAndMessaging::*;

use crate::{input, log, painter::Painter, ui};

type PresentFn = unsafe extern "system" fn(*mut c_void, u32, u32) -> HRESULT;
type ResizeBuffersFn =
    unsafe extern "system" fn(*mut c_void, u32, u32, u32, DXGI_FORMAT, u32) -> HRESULT;

static PRESENT_ORIG: AtomicUsize = AtomicUsize::new(0);
static RESIZE_ORIG: AtomicUsize = AtomicUsize::new(0);
static WARNED_NOT_D3D11: AtomicBool = AtomicBool::new(false);

/// Per-swapchain render state. Only touched from Present/ResizeBuffers, which
/// both run on UE's RHI thread; the Mutex is for Rust's sake, never contended.
struct Overlay {
    swapchain: usize,
    painter: Painter,
    ctx: egui::Context,
    ui: ui::Panels,
}

// COM pointers are not Send in windows-rs; every access is on the RHI thread.
struct OverlaySlot(Option<Overlay>);
unsafe impl Send for OverlaySlot {}

static OVERLAY: Mutex<OverlaySlot> = Mutex::new(OverlaySlot(None));

fn fail(msg: impl std::fmt::Display) -> Error {
    Error::new(E_FAIL, msg.to_string())
}

// IDXGISwapChain vtable: IUnknown(3) + IDXGIObject(4) + IDXGIDeviceSubObject(1),
// then Present(8) .. ResizeBuffers(13).
const VT_PRESENT: usize = 8;
const VT_RESIZE_BUFFERS: usize = 13;

pub unsafe fn install() -> Result<()> {
    let (present, resize) = swapchain_vtable_entries()?;

    let present_detour =
        RawDetour::new(present as *const (), present_hook as *const ()).map_err(fail)?;
    let resize_detour =
        RawDetour::new(resize as *const (), resize_hook as *const ()).map_err(fail)?;

    PRESENT_ORIG.store(present_detour.trampoline() as *const () as usize, Ordering::SeqCst);
    RESIZE_ORIG.store(resize_detour.trampoline() as *const () as usize, Ordering::SeqCst);

    present_detour
        .enable()
        .and_then(|_| resize_detour.enable())
        .map_err(fail)?;

    // The detours live for the life of the process: the DLL is never unloaded.
    std::mem::forget(present_detour);
    std::mem::forget(resize_detour);
    log::info("Present/ResizeBuffers hooked");
    Ok(())
}

unsafe fn swapchain_vtable_entries() -> Result<(usize, usize)> {
    let hwnd = CreateWindowExW(
        WINDOW_EX_STYLE::default(),
        w!("STATIC"),
        w!("mt_overlay_dummy"),
        WS_OVERLAPPEDWINDOW,
        0,
        0,
        16,
        16,
        HWND::default(),
        HMENU::default(),
        HINSTANCE::default(),
        None,
    )?;

    let desc = DXGI_SWAP_CHAIN_DESC {
        BufferDesc: DXGI_MODE_DESC {
            Width: 16,
            Height: 16,
            Format: DXGI_FORMAT_R8G8B8A8_UNORM,
            ..Default::default()
        },
        SampleDesc: DXGI_SAMPLE_DESC { Count: 1, Quality: 0 },
        BufferUsage: DXGI_USAGE_RENDER_TARGET_OUTPUT,
        BufferCount: 1,
        OutputWindow: hwnd,
        Windowed: TRUE,
        SwapEffect: DXGI_SWAP_EFFECT_DISCARD,
        Flags: 0,
    };

    let mut swapchain: Option<IDXGISwapChain> = None;
    let mut device: Option<ID3D11Device> = None;
    let created = D3D11CreateDeviceAndSwapChain(
        None,
        D3D_DRIVER_TYPE_HARDWARE,
        HMODULE::default(),
        D3D11_CREATE_DEVICE_FLAG(0),
        None,
        D3D11_SDK_VERSION,
        Some(&desc),
        Some(&mut swapchain),
        Some(&mut device),
        None,
        None,
    );

    let result = created.and_then(|_| {
        let sc = swapchain.as_ref().ok_or_else(|| fail("no swapchain"))?;
        let vtable = *(sc.as_raw() as *const *const usize);
        Ok((*vtable.add(VT_PRESENT), *vtable.add(VT_RESIZE_BUFFERS)))
    });

    drop(swapchain);
    drop(device);
    let _ = DestroyWindow(hwnd);
    result
}

unsafe extern "system" fn present_hook(this: *mut c_void, sync: u32, flags: u32) -> HRESULT {
    // Never let a panic, or a broken frame of ours, take the game's frame down.
    let _ = catch_unwind(AssertUnwindSafe(|| {
        if let Err(e) = draw_overlay(this) {
            log::warn(&format!("overlay frame failed: {e}"));
        }
    }));
    let orig: PresentFn = std::mem::transmute(PRESENT_ORIG.load(Ordering::Relaxed));
    orig(this, sync, flags)
}

unsafe extern "system" fn resize_hook(
    this: *mut c_void,
    count: u32,
    width: u32,
    height: u32,
    format: DXGI_FORMAT,
    flags: u32,
) -> HRESULT {
    // Our RTV holds a reference to the old back buffer; ResizeBuffers fails
    // with DXGI_ERROR_INVALID_CALL until every such reference is released.
    if let Ok(mut guard) = OVERLAY.lock() {
        if let Some(o) = guard.0.as_mut() {
            if o.swapchain == this as usize {
                o.painter.release_target();
            }
        }
    }
    let orig: ResizeBuffersFn = std::mem::transmute(RESIZE_ORIG.load(Ordering::Relaxed));
    orig(this, count, width, height, format, flags)
}

unsafe fn draw_overlay(this: *mut c_void) -> Result<()> {
    let Some(swapchain) = IDXGISwapChain::from_raw_borrowed(&this) else {
        return Ok(());
    };

    let mut guard = OVERLAY.lock().unwrap_or_else(|p| p.into_inner());

    // First frame (or the game recreated its swapchain): build everything.
    if guard.0.as_ref().map(|o| o.swapchain) != Some(this as usize) {
        let device: ID3D11Device = match swapchain.GetDevice() {
            Ok(d) => d,
            Err(_) => {
                if !WARNED_NOT_D3D11.swap(true, Ordering::Relaxed) {
                    log::warn("swapchain is not D3D11 (D3D12?) - launch with -dx11; overlay disabled");
                }
                return Ok(());
            }
        };
        let desc = swapchain.GetDesc()?;
        input::install(desc.OutputWindow);
        let painter = Painter::new(&device)?;
        let ctx = egui::Context::default();
        ctx.set_visuals(egui::Visuals::dark());
        guard.0 = Some(Overlay {
            swapchain: this as usize,
            painter,
            ctx,
            ui: ui::Panels::default(),
        });
        log::info(&format!(
            "overlay ready: {}x{} {:?}",
            desc.BufferDesc.Width, desc.BufferDesc.Height, desc.BufferDesc.Format
        ));
    }
    let overlay = guard.0.as_mut().expect("overlay was just created");

    // Keep feeding egui while hidden so it does not see a burst of stale
    // input on open, but skip the paint entirely.
    let (width, height) = overlay.painter.ensure_target(swapchain)?;
    let raw_input = input::take_raw_input(width as f32, height as f32);
    if !crate::any_open() {
        // Nothing on screen: nothing of ours may hold input.
        input::set_wants_input(false, false, false, Vec::new(), width as f32, height as f32);
        return Ok(());
    }

    let output = overlay.ctx.run(raw_input, |ctx| overlay.ui.show(ctx));
    let ppp = output.pixels_per_point;
    let panels_px = overlay
        .ui
        .open_rects(&overlay.ctx)
        .into_iter()
        .map(|r| egui::Rect::from_min_max((r.min.to_vec2() * ppp).to_pos2(), (r.max.to_vec2() * ppp).to_pos2()))
        .collect();
    input::set_wants_input(
        // Not wants_pointer_input(): that includes hover, which can be stale.
        overlay.ctx.is_using_pointer(),
        overlay.ctx.is_pointer_over_area(),
        overlay.ctx.wants_keyboard_input(),
        panels_px,
        width as f32,
        height as f32,
    );
    let primitives = overlay.ctx.tessellate(output.shapes, output.pixels_per_point);
    overlay
        .painter
        .paint(&primitives, &output.textures_delta, output.pixels_per_point)
}
