//! DXGI hooks: detour `IDXGISwapChain::Present` and `ResizeBuffers`.
//!
//! The vtable addresses come from a throwaway D3D11 device + swapchain on a
//! hidden window; the functions live in dxgi.dll and are shared by every
//! swapchain in the process, so detouring them catches the game's too.
//!
//! Device dispatch: `GetDevice::<ID3D12Device>` is tried first, then
//! `ID3D11Device`, so the overlay works with or without `-dx11`. For D3D12
//! the swapchain's presenting command queue is needed; it is captured by
//! detouring `ID3D12CommandQueue::ExecuteCommandLists` (vtable read off a
//! throwaway queue, same trick as the Present/ResizeBuffers detours).

use std::ffi::c_void;
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::sync::Mutex;

use retour::RawDetour;
use windows::core::{w, Error, Interface, Result, HRESULT};
use windows::Win32::Foundation::{E_FAIL, HINSTANCE, HMODULE, HWND, TRUE};
use windows::Win32::Graphics::Direct3D::D3D_DRIVER_TYPE_HARDWARE;
use windows::Win32::Graphics::Direct3D::D3D_FEATURE_LEVEL_11_0;
use windows::Win32::Graphics::Direct3D12::{
    D3D12CreateDevice, ID3D12CommandQueue, ID3D12Device, D3D12_COMMAND_LIST_TYPE_DIRECT,
};
use windows::Win32::Graphics::Direct3D11::*;
use windows::Win32::Graphics::Dxgi::Common::*;
use windows::Win32::Graphics::Dxgi::*;
use windows::Win32::UI::WindowsAndMessaging::*;

use crate::{input, log, painter::Painter, painter12, ui};

type PresentFn = unsafe extern "system" fn(*mut c_void, u32, u32) -> HRESULT;
type ResizeBuffersFn =
    unsafe extern "system" fn(*mut c_void, u32, u32, u32, DXGI_FORMAT, u32) -> HRESULT;
// ExecuteCommandLists returns void.
type ExecuteCommandListsFn =
    unsafe extern "system" fn(*mut c_void, u32, *const *mut c_void);

static PRESENT_ORIG: AtomicUsize = AtomicUsize::new(0);
static RESIZE_ORIG: AtomicUsize = AtomicUsize::new(0);
static EXEC_ORIG: AtomicUsize = AtomicUsize::new(0);
static D3D12_QUEUE_CAPTURED: AtomicBool = AtomicBool::new(false);
static WARNED_NO_DEVICE: AtomicBool = AtomicBool::new(false);

/// Per-swapchain render state. Only touched from Present/ResizeBuffers, which
/// both run on UE's RHI thread; the Mutex is for Rust's sake, never contended.
struct Overlay {
    swapchain: usize,
    painter: PainterAny,
    ctx: egui::Context,
    ui: ui::Panels,
}

/// The two back ends, exposing painter.rs's public API.
enum PainterAny {
    D3d11(Painter),
    D3d12(painter12::Painter),
}

impl PainterAny {
    unsafe fn ensure_target(&mut self, swapchain: &IDXGISwapChain) -> Result<(u32, u32)> {
        match self {
            Self::D3d11(p) => p.ensure_target(swapchain),
            Self::D3d12(p) => p.ensure_target(swapchain),
        }
    }

    fn release_target(&mut self) {
        match self {
            Self::D3d11(p) => p.release_target(),
            Self::D3d12(p) => p.release_target(),
        }
    }

    unsafe fn paint(
        &mut self,
        back_index: u32,
        primitives: &[egui::epaint::ClippedPrimitive],
        delta: &egui::TexturesDelta,
        ppp: f32,
    ) -> Result<()> {
        match self {
            Self::D3d11(p) => p.paint(primitives, delta, ppp),
            Self::D3d12(p) => {
                let queue = captured_queue();
                p.paint(queue.as_ref(), back_index, primitives, delta, ppp)
            }
        }
    }
}

// COM pointers are not Send in windows-rs; every access is on the RHI thread.
struct OverlaySlot(Option<Overlay>);
unsafe impl Send for OverlaySlot {}

static OVERLAY: Mutex<OverlaySlot> = Mutex::new(OverlaySlot(None));

/// The game's presenting D3D12 command queue, captured from the first
/// ExecuteCommandLists call. Only touched from Present + the exec hook, which
/// both run on the RHI thread; Mutex is for Rust's sake.
struct QueueSlot(Option<windows::Win32::Graphics::Direct3D12::ID3D12CommandQueue>);
unsafe impl Send for QueueSlot {}

static D3D12_QUEUE: Mutex<QueueSlot> = Mutex::new(QueueSlot(None));

fn captured_queue() -> Option<windows::Win32::Graphics::Direct3D12::ID3D12CommandQueue> {
    D3D12_QUEUE
        .lock()
        .unwrap_or_else(|p| p.into_inner())
        .0
        .clone()
}

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

    // Optional second detour: capture the game's presenting D3D12 command
    // queue. Best effort — D3D12 may be absent (DX11-only system), in which
    // case the D3D12 painter simply never gets a queue and stays idle.
    match install_exec_hook() {
        Ok(()) => log::info("Present/ResizeBuffers/ExecuteCommandLists hooked"),
        Err(e) => {
            log::info("Present/ResizeBuffers hooked");
            log::warn(&format!("D3D12 queue capture unavailable: {e}"));
        }
    }
    Ok(())
}

/// Detour ID3D12CommandQueue::ExecuteCommandLists so we learn the queue the
/// game (and thus the swapchain) presents with. The vtable entry is read off
/// a throwaway queue, so no vtable index is hardcoded.
unsafe fn install_exec_hook() -> Result<()> {
    let exec = exec_vtable_entry()?;
    let detour = RawDetour::new(exec as *const (), exec_hook as *const ()).map_err(fail)?;
    EXEC_ORIG.store(
        detour.trampoline() as *const () as usize,
        Ordering::SeqCst,
    );
    detour.enable().map_err(fail)?;
    std::mem::forget(detour);
    Ok(())
}

unsafe fn exec_vtable_entry() -> Result<ExecuteCommandListsFn> {
    let mut device: Option<windows::Win32::Graphics::Direct3D12::ID3D12Device> = None;
    D3D12CreateDevice(None, D3D_FEATURE_LEVEL_11_0, &mut device)?;
    let device = device.ok_or_else(|| fail("no D3D12 device"))?;
    let desc = windows::Win32::Graphics::Direct3D12::D3D12_COMMAND_QUEUE_DESC::default();
    let queue: ID3D12CommandQueue = device.CreateCommandQueue(&desc)?;
    // Read ExecuteCommandLists directly from the typed vtable (index 10)
    // instead of hardcoding a raw offset.
    let f = Interface::vtable(&queue).ExecuteCommandLists as usize;
    Ok(std::mem::transmute::<usize, ExecuteCommandListsFn>(f))
}

unsafe extern "system" fn exec_hook(
    this: *mut c_void,
    count: u32,
    lists: *const *mut c_void,
) {
    // Fast path: once we have captured the DIRECT queue, avoid locking on
    // every ExecuteCommandLists submission.
    if !D3D12_QUEUE_CAPTURED.load(Ordering::Relaxed) {
        if let Some(q) = ID3D12CommandQueue::from_raw_borrowed(&this) {
            if q.GetDesc().Type == D3D12_COMMAND_LIST_TYPE_DIRECT {
                let mut slot = D3D12_QUEUE.lock().unwrap_or_else(|p| p.into_inner());
                if slot.0.is_none() {
                    slot.0 = Some(q.clone());
                    D3D12_QUEUE_CAPTURED.store(true, Ordering::Release);
                    drop(slot);
                    log::info("captured D3D12 DIRECT command queue");
                }
            }
        }
    }
    let orig: ExecuteCommandListsFn = std::mem::transmute(EXEC_ORIG.load(Ordering::Relaxed));
    orig(this, count, lists)
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
        let desc = swapchain.GetDesc()?;
        input::install(desc.OutputWindow);
        let ctx = egui::Context::default();
        ctx.set_visuals(egui::Visuals::dark());
        // UE5 defaults to D3D12; Motor Town's -dx11 path is D3D11. Try D3D12
        // first, then fall back to the original D3D11 painter.
        let (painter, api) = if let Ok(d3d12) = swapchain.GetDevice::<ID3D12Device>() {
            (PainterAny::D3d12(painter12::Painter::new(&d3d12)?), "D3D12")
        } else if let Ok(device) = swapchain.GetDevice::<ID3D11Device>() {
            (PainterAny::D3d11(Painter::new(&device)?), "D3D11")
        } else {
            if !WARNED_NO_DEVICE.swap(true, Ordering::Relaxed) {
                log::warn("swapchain device is neither D3D11 nor D3D12; overlay disabled");
            }
            return Ok(());
        };
        guard.0 = Some(Overlay {
            swapchain: this as usize,
            painter,
            ctx,
            ui: ui::Panels::default(),
        });
        log::info(&format!(
            "overlay ready ({}): {}x{} {:?}",
            api, desc.BufferDesc.Width, desc.BufferDesc.Height, desc.BufferDesc.Format
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
    let back_index = swapchain
        .cast::<windows::Win32::Graphics::Dxgi::IDXGISwapChain3>()
        .map(|sc| sc.GetCurrentBackBufferIndex())
        .unwrap_or(0);
    overlay
        .painter
        .paint(back_index, &primitives, &output.textures_delta, output.pixels_per_point)
}
