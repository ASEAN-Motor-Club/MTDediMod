//! DXGI hooks: detour `IDXGISwapChain::Present` and `ResizeBuffers`, plus
//! `ID3D12CommandQueue::ExecuteCommandLists` for D3D12 (UE5 default) via
//! D3D11On12.
//!
//! The vtable addresses come from throwaway D3D11/D3D12 objects on a hidden
//! window; the functions live in dxgi.dll / d3d12.dll and are shared by every
//! swapchain / command queue in the process, so detouring them catches the
//! game's too.
//!
//! Under D3D11, `Painter` renders straight onto the swapchain's back buffer.
//! Under D3D12, we capture the game's `DIRECT` command queue from
//! `ExecuteCommandLists`, create a `D3D11On12` bridge device on it, wrap each
//! DX12 back buffer as an `ID3D11Resource` (`PRESENT` -> `PRESENT`), and draw
//! through the exact same `Painter`.

use std::ffi::c_void;
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::sync::Mutex;

use retour::RawDetour;
use windows::core::{w, Error, IUnknown, Interface, Result, HRESULT};
use windows::Win32::Foundation::{E_FAIL, HINSTANCE, HMODULE, HWND, TRUE};
use windows::Win32::Graphics::Direct3D::{D3D_DRIVER_TYPE_HARDWARE, D3D_FEATURE_LEVEL_11_0};
use windows::Win32::Graphics::Direct3D11::*;
use windows::Win32::Graphics::Direct3D11on12::*;
use windows::Win32::Graphics::Direct3D12::*;
use windows::Win32::Graphics::Dxgi::Common::*;
use windows::Win32::Graphics::Dxgi::*;
use windows::Win32::UI::WindowsAndMessaging::*;

use crate::{input, log, painter::Painter, ui};

type PresentFn = unsafe extern "system" fn(*mut c_void, u32, u32) -> HRESULT;
type ResizeBuffersFn =
    unsafe extern "system" fn(*mut c_void, u32, u32, u32, DXGI_FORMAT, u32) -> HRESULT;
type ExecuteCommandListsFn = unsafe extern "system" fn(*mut c_void, u32, *const *mut c_void);

static PRESENT_ORIG: AtomicUsize = AtomicUsize::new(0);
static RESIZE_ORIG: AtomicUsize = AtomicUsize::new(0);
static EXEC_CL_ORIG: AtomicUsize = AtomicUsize::new(0);

static DX12_TARGET_DEVICE: AtomicUsize = AtomicUsize::new(0);
static DX12_QUEUE_READY: AtomicBool = AtomicBool::new(false);
static WARNED_UNSUPPORTED: AtomicBool = AtomicBool::new(false);

struct Dx12Buffer {
    wrapped: ID3D11Resource,
    rtv: ID3D11RenderTargetView,
}

struct Dx12State {
    on12: ID3D11On12Device,
    buffers: Vec<Dx12Buffer>,
    width: u32,
    height: u32,
}

enum Backend {
    D3D11,
    D3D12(Dx12State),
}

/// Per-swapchain render state. Only touched from Present/ResizeBuffers, which
/// both run on UE's RHI thread; the Mutex is for Rust's sake, never contended.
struct Overlay {
    swapchain: usize,
    backend: Backend,
    painter: Painter,
    ctx: egui::Context,
    ui: ui::Panels,
}

// COM pointers are not Send in windows-rs; every access is on the RHI thread.
struct OverlaySlot(Option<Overlay>);
unsafe impl Send for OverlaySlot {}

struct QueueSlot(Option<ID3D12CommandQueue>);
unsafe impl Send for QueueSlot {}

static OVERLAY: Mutex<OverlaySlot> = Mutex::new(OverlaySlot(None));
static CAPTURED_QUEUE: Mutex<QueueSlot> = Mutex::new(QueueSlot(None));

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

    // Best-effort D3D12 command queue hook so DX12 (UE5 default) works without
    // `-dx11`. If D3D12 is unavailable on this machine, D3D11 still works.
    match install_d3d12_hook() {
        Ok(()) => log::info("D3D12 ExecuteCommandLists hooked (D3D11On12 enabled)"),
        Err(e) => log::warn(&format!("D3D12 hook unavailable (D3D11 only): {e}")),
    }
    Ok(())
}

unsafe fn install_d3d12_hook() -> Result<()> {
    let mut device: Option<ID3D12Device> = None;
    D3D12CreateDevice(None::<&IUnknown>, D3D_FEATURE_LEVEL_11_0, &mut device)?;
    let device = device.ok_or_else(|| fail("D3D12CreateDevice returned null"))?;

    let desc = D3D12_COMMAND_QUEUE_DESC {
        Type: D3D12_COMMAND_LIST_TYPE_DIRECT,
        Priority: D3D12_COMMAND_QUEUE_PRIORITY_NORMAL.0,
        Flags: D3D12_COMMAND_QUEUE_FLAG_NONE,
        NodeMask: 0,
    };
    let queue: ID3D12CommandQueue = device.CreateCommandQueue(&desc)?;
    let exec_fn = Interface::vtable(&queue).ExecuteCommandLists as usize;
    drop(queue);
    drop(device);

    let exec_detour =
        RawDetour::new(exec_fn as *const (), execute_command_lists_hook as *const ())
            .map_err(fail)?;
    EXEC_CL_ORIG.store(exec_detour.trampoline() as *const () as usize, Ordering::SeqCst);
    exec_detour.enable().map_err(fail)?;
    std::mem::forget(exec_detour);
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

unsafe extern "system" fn execute_command_lists_hook(
    this: *mut c_void,
    num_lists: u32,
    lists: *const *mut c_void,
) {
    // Fast path: once we have the game's DIRECT command queue, do a single
    // atomic load and pass straight through.
    if !DX12_QUEUE_READY.load(Ordering::Relaxed) {
        let target_dev = DX12_TARGET_DEVICE.load(Ordering::Relaxed);
        if target_dev != 0 {
            let _ = catch_unwind(AssertUnwindSafe(|| {
                if let Some(queue) = ID3D12CommandQueue::from_raw_borrowed(&this) {
                    if queue.GetDesc().Type == D3D12_COMMAND_LIST_TYPE_DIRECT {
                        let mut dev: Option<ID3D12Device> = None;
                        if queue.GetDevice(&mut dev).is_ok() {
                            if let Some(d) = dev {
                                if d.as_raw() as usize == target_dev {
                                    if let Ok(mut slot) = CAPTURED_QUEUE.try_lock() {
                                        if slot.0.is_none() {
                                            slot.0 = Some(queue.clone());
                                            DX12_QUEUE_READY.store(true, Ordering::Release);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }));
        }
    }
    let orig: ExecuteCommandListsFn = std::mem::transmute(EXEC_CL_ORIG.load(Ordering::Relaxed));
    orig(this, num_lists, lists);
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
    // Our RTVs / wrapped back buffers hold references to the old swapchain
    // buffers; ResizeBuffers fails with DXGI_ERROR_INVALID_CALL until every
    // such reference is released and (on D3D11On12) flushed.
    if let Ok(mut guard) = OVERLAY.lock() {
        if let Some(o) = guard.0.as_mut() {
            if o.swapchain == this as usize {
                o.painter.release_target();
                if let Backend::D3D12(dx12) = &mut o.backend {
                    dx12.buffers.clear();
                    o.painter.context().Flush();
                }
            }
        }
    }
    let orig: ResizeBuffersFn = std::mem::transmute(RESIZE_ORIG.load(Ordering::Relaxed));
    orig(this, count, width, height, format, flags)
}

unsafe fn ensure_dx12_targets(
    swapchain: &IDXGISwapChain,
    painter: &Painter,
    dx12: &mut Dx12State,
) -> Result<(u32, u32)> {
    if !dx12.buffers.is_empty() {
        return Ok((dx12.width, dx12.height));
    }
    let desc = swapchain.GetDesc()?;
    let count = desc.BufferCount.max(1);
    let flags11 = D3D11_RESOURCE_FLAGS {
        BindFlags: D3D11_BIND_RENDER_TARGET.0 as u32,
        ..Default::default()
    };

    let mut buffers = Vec::with_capacity(count as usize);
    for i in 0..count {
        let back12: ID3D12Resource = swapchain.GetBuffer(i)?;
        let mut wrapped: Option<ID3D11Resource> = None;
        // At IDXGISwapChain::Present time, UE5 has already transitioned the
        // back buffer to PRESENT state, and Present requires PRESENT on exit.
        dx12.on12.CreateWrappedResource(
            &back12,
            &flags11,
            D3D12_RESOURCE_STATE_PRESENT,
            D3D12_RESOURCE_STATE_PRESENT,
            &mut wrapped,
        )?;
        let wrapped = wrapped.ok_or_else(|| fail("CreateWrappedResource returned null"))?;
        let mut rtv: Option<ID3D11RenderTargetView> = None;
        painter.device().CreateRenderTargetView(&wrapped, None, Some(&mut rtv))?;
        let rtv = rtv.ok_or_else(|| fail("no D3D11On12 RTV"))?;
        buffers.push(Dx12Buffer { wrapped, rtv });
    }
    dx12.buffers = buffers;
    dx12.width = desc.BufferDesc.Width;
    dx12.height = desc.BufferDesc.Height;
    Ok((dx12.width, dx12.height))
}

unsafe fn init_overlay(this: *mut c_void, swapchain: &IDXGISwapChain) -> Result<Option<Overlay>> {
    // 1. Native D3D11 path.
    if let Ok(device) = swapchain.GetDevice::<ID3D11Device>() {
        let desc = swapchain.GetDesc()?;
        input::install(desc.OutputWindow);
        let painter = Painter::new(&device)?;
        let ctx = egui::Context::default();
        ctx.set_visuals(egui::Visuals::dark());
        log::info(&format!(
            "overlay ready (D3D11): {}x{} {:?}",
            desc.BufferDesc.Width, desc.BufferDesc.Height, desc.BufferDesc.Format
        ));
        return Ok(Some(Overlay {
            swapchain: this as usize,
            backend: Backend::D3D11,
            painter,
            ctx,
            ui: ui::Panels::default(),
        }));
    }

    // 2. D3D12 path via D3D11On12.
    if let Ok(d3d12_device) = swapchain.GetDevice::<ID3D12Device>() {
        let dev_ptr = d3d12_device.as_raw() as usize;
        if DX12_TARGET_DEVICE.load(Ordering::Relaxed) != dev_ptr {
            // Reset any queue captured for an earlier device (e.g. device lost).
            if let Ok(mut slot) = CAPTURED_QUEUE.lock() {
                slot.0 = None;
            }
            DX12_QUEUE_READY.store(false, Ordering::Release);
            DX12_TARGET_DEVICE.store(dev_ptr, Ordering::Release);
        }

        if !DX12_QUEUE_READY.load(Ordering::Acquire) {
            // Wait a frame for ExecuteCommandLists to hand us the DIRECT queue.
            return Ok(None);
        }

        let queue = {
            let slot = CAPTURED_QUEUE.lock().unwrap_or_else(|p| p.into_inner());
            match slot.0.clone() {
                Some(q) => q,
                None => return Ok(None),
            }
        };

        let queue_unk: IUnknown = queue.cast()?;
        let queues = [Some(queue_unk)];
        let mut d3d11_device: Option<ID3D11Device> = None;
        D3D11On12CreateDevice(
            &d3d12_device,
            D3D11_CREATE_DEVICE_BGRA_SUPPORT.0,
            None,
            Some(&queues),
            0,
            Some(&mut d3d11_device),
            None,
            None,
        )?;
        let d3d11_device =
            d3d11_device.ok_or_else(|| fail("D3D11On12CreateDevice returned null"))?;
        let on12: ID3D11On12Device = d3d11_device.cast()?;

        let desc = swapchain.GetDesc()?;
        input::install(desc.OutputWindow);
        let painter = Painter::new(&d3d11_device)?;
        let ctx = egui::Context::default();
        ctx.set_visuals(egui::Visuals::dark());
        log::info(&format!(
            "overlay ready (D3D12 via D3D11On12): {}x{} {:?} ({} buffers)",
            desc.BufferDesc.Width,
            desc.BufferDesc.Height,
            desc.BufferDesc.Format,
            desc.BufferCount
        ));
        return Ok(Some(Overlay {
            swapchain: this as usize,
            backend: Backend::D3D12(Dx12State {
                on12,
                buffers: Vec::new(),
                width: desc.BufferDesc.Width,
                height: desc.BufferDesc.Height,
            }),
            painter,
            ctx,
            ui: ui::Panels::default(),
        }));
    }

    if !WARNED_UNSUPPORTED.swap(true, Ordering::Relaxed) {
        log::warn("swapchain is neither D3D11 nor D3D12 - overlay disabled");
    }
    Ok(None)
}

unsafe fn draw_overlay(this: *mut c_void) -> Result<()> {
    let Some(swapchain) = IDXGISwapChain::from_raw_borrowed(&this) else {
        return Ok(());
    };

    let mut guard = OVERLAY.lock().unwrap_or_else(|p| p.into_inner());

    // First frame (or the game recreated its swapchain): build everything.
    if guard.0.as_ref().map(|o| o.swapchain) != Some(this as usize) {
        if let Some(old) = guard.0.as_mut() {
            old.painter.release_target();
            if let Backend::D3D12(dx12) = &mut old.backend {
                dx12.buffers.clear();
                old.painter.context().Flush();
            }
        }
        guard.0 = init_overlay(this, swapchain)?;
        if guard.0.is_none() {
            return Ok(());
        }
    }
    let overlay = guard.0.as_mut().expect("overlay was just created");

    // Resolve current viewport size (and back-buffer RTVs).
    let (width, height) = match &mut overlay.backend {
        Backend::D3D11 => overlay.painter.ensure_target(swapchain)?,
        Backend::D3D12(dx12) => ensure_dx12_targets(swapchain, &overlay.painter, dx12)?,
    };

    // Keep feeding egui while hidden so it does not see a burst of stale
    // input on open, but skip the paint entirely.
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
        .map(|r| {
            egui::Rect::from_min_max(
                (r.min.to_vec2() * ppp).to_pos2(),
                (r.max.to_vec2() * ppp).to_pos2(),
            )
        })
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

    match &mut overlay.backend {
        Backend::D3D11 => overlay
            .painter
            .paint(&primitives, &output.textures_delta, output.pixels_per_point),
        Backend::D3D12(dx12) => {
            let sc3: IDXGISwapChain3 = swapchain.cast()?;
            let idx = sc3.GetCurrentBackBufferIndex() as usize;
            let Some(buf) = dx12.buffers.get(idx) else {
                return Ok(());
            };
            let res = [Some(buf.wrapped.clone())];
            dx12.on12.AcquireWrappedResources(&res);
            overlay.painter.set_target(buf.rtv.clone(), width, height);
            let paint_res = overlay.painter.paint(
                &primitives,
                &output.textures_delta,
                output.pixels_per_point,
            );
            overlay.painter.release_target();
            dx12.on12.ReleaseWrappedResources(&res);
            overlay.painter.context().Flush();
            static LOGGED_FIRST: AtomicBool = AtomicBool::new(false);
            if paint_res.is_ok() && !LOGGED_FIRST.swap(true, Ordering::Relaxed) {
                log::info(&format!(
                    "D3D11On12 first frame rendered ({}x{}, back_index={})",
                    width, height, idx
                ));
            }
            paint_res
        }
    }
}
