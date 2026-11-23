//! Out-of-game test for mt_overlay.dll: a D3D11 window standing in for the
//! game, plus a fake Lua client on the bridge pipes.
//!
//!   cargo build --release && cargo run --release --example harness
//!
//! Loads the DLL, opens the panel through the bridge (`events: ["toggle"]`),
//! renders frames for a few seconds, writes the back buffer to
//! `target/harness.bmp`, and prints the commands the panel sent.

use std::fs::OpenOptions;
use std::io::{BufRead, BufReader, Write};
use std::time::{Duration, Instant};

use windows::core::{w, Result};
use windows::Win32::Foundation::*;
use windows::Win32::Graphics::Direct3D::D3D_DRIVER_TYPE_HARDWARE;
use windows::Win32::Graphics::Direct3D11::*;
use windows::Win32::Graphics::Dxgi::Common::*;
use windows::Win32::Graphics::Dxgi::*;
use windows::Win32::System::LibraryLoader::{GetModuleHandleW, LoadLibraryW};
use windows::Win32::UI::Input::KeyboardAndMouse::VK_TAB;
use windows::Win32::UI::WindowsAndMessaging::*;

const W: u32 = 1280;
const H: u32 = 720;

/// Clicks that reached the "game" WndProc, i.e. the overlay let through.
static GAME_CLICKS: std::sync::atomic::AtomicU32 = std::sync::atomic::AtomicU32::new(0);

unsafe extern "system" fn wndproc(hwnd: HWND, msg: u32, wp: WPARAM, lp: LPARAM) -> LRESULT {
    if msg == WM_LBUTTONDOWN {
        GAME_CLICKS.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
    }
    if msg == WM_DESTROY {
        PostQuitMessage(0);
        return LRESULT(0);
    }
    DefWindowProcW(hwnd, msg, wp, lp)
}

fn main() -> Result<()> {
    unsafe { run() }
}

unsafe fn run() -> Result<()> {
    let instance: HINSTANCE = GetModuleHandleW(None)?.into();
    let class = WNDCLASSW {
        lpfnWndProc: Some(wndproc),
        hInstance: instance,
        lpszClassName: w!("mt_overlay_harness"),
        hCursor: LoadCursorW(None, IDC_ARROW)?,
        ..Default::default()
    };
    RegisterClassW(&class);
    let mut rect = RECT { left: 0, top: 0, right: W as i32, bottom: H as i32 };
    AdjustWindowRect(&mut rect, WS_OVERLAPPEDWINDOW, false)?;
    let (win_w, win_h) = (rect.right - rect.left, rect.bottom - rect.top);
    // Open in the corner away from the real cursor: real mouse moves over the
    // window would override the scripted pointer position.
    let mut cursor = POINT::default();
    GetCursorPos(&mut cursor)?;
    let (sw, sh) = (GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
    let x = if cursor.x < sw / 2 { (sw - win_w).max(0) } else { 0 };
    let y = if cursor.y < sh / 2 { (sh - win_h).max(0) } else { 0 };
    if (x..x + win_w).contains(&cursor.x) && (y..y + win_h).contains(&cursor.y) {
        println!("warning: the cursor is over the test window; move it away or the drag test may fail");
    }
    let hwnd = CreateWindowExW(
        WINDOW_EX_STYLE::default(),
        w!("mt_overlay_harness"),
        w!("mt_overlay harness"),
        WS_OVERLAPPEDWINDOW | WS_VISIBLE,
        x,
        y,
        win_w,
        win_h,
        None,
        None,
        instance,
        None,
    )?;

    let desc = DXGI_SWAP_CHAIN_DESC {
        BufferDesc: DXGI_MODE_DESC {
            Width: W,
            Height: H,
            Format: DXGI_FORMAT_R8G8B8A8_UNORM,
            ..Default::default()
        },
        SampleDesc: DXGI_SAMPLE_DESC { Count: 1, Quality: 0 },
        BufferUsage: DXGI_USAGE_RENDER_TARGET_OUTPUT,
        BufferCount: 2,
        OutputWindow: hwnd,
        Windowed: TRUE,
        SwapEffect: DXGI_SWAP_EFFECT_FLIP_DISCARD,
        Flags: 0,
    };
    let mut swapchain: Option<IDXGISwapChain> = None;
    let mut device: Option<ID3D11Device> = None;
    let mut context: Option<ID3D11DeviceContext> = None;
    D3D11CreateDeviceAndSwapChain(
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
        Some(&mut context),
    )?;
    let (swapchain, device, context) = (swapchain.unwrap(), device.unwrap(), context.unwrap());

    // What the Lua mod does: map the DLL, then talk over the pipes.
    let dll = std::env::current_exe().unwrap().parent().unwrap().join("../mt_overlay.dll");
    // Start from default window positions, unless checking that a saved
    // layout is restored (`harness --keep-layout`).
    let layout = dll.with_file_name("mt_overlay_layout.json");
    if !std::env::args().any(|a| a == "--keep-layout") {
        let _ = std::fs::remove_file(&layout);
    }
    let dll_w: Vec<u16> = dll.to_string_lossy().encode_utf16().chain(Some(0)).collect();
    LoadLibraryW(windows::core::PCWSTR(dll_w.as_ptr()))?;
    println!("loaded {}", dll.display());

    let deadline = Instant::now() + Duration::from_secs(5);
    let (mut up, down) = loop {
        let up = OpenOptions::new().write(true).open(r"\\.\pipe\mt_overlay_up");
        let down = OpenOptions::new().read(true).open(r"\\.\pipe\mt_overlay_down");
        if let (Ok(u), Ok(d)) = (up, down) {
            break (u, BufReader::new(d));
        }
        assert!(Instant::now() < deadline, "bridge pipes never appeared");
        std::thread::sleep(Duration::from_millis(50));
    };
    let mut down = down;
    println!("bridge connected");

    let state = r#"{"impulse_mode":"raw","impulse_strength":100000,"speed_kmh":20,"direction":"angled","origin":"impact","right_click":"despawn","aimed_mass_kg":1015}"#;
    let mut first = true;
    let mut poll = |events: &str| -> String {
        let line = format!("{{\"state\":{state}{events}}}\n");
        up.write_all(line.as_bytes()).unwrap();
        up.flush().unwrap();
        let mut resp = String::new();
        down.read_line(&mut resp).unwrap();
        resp
    };

    let start = Instant::now();
    let mut last_poll = Instant::now();
    let mut step = 0;
    let mut msg = MSG::default();
    while start.elapsed() < Duration::from_secs(3) {
        while PeekMessageW(&mut msg, None, 0, 0, PM_REMOVE).as_bool() {
            let _ = TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }
        if last_poll.elapsed() >= Duration::from_millis(50) {
            last_poll = Instant::now();
            // First poll: open both windows and send Lua's fallback points,
            // as OverlayBridge.lua does once per connection.
            let resp = poll(if first {
                r#","events":["toggle","toggle_teleport"],"teleport_points":["alpha","bravo","charlie"]"#
            } else {
                ""
            });
            if first || resp.contains("\"op\"") {
                println!("response: {}", resp.trim());
            }
            first = false;
        }

        // Scripted input, one action per ~100 ms so egui sees each in its
        // own frame. Coordinates are the default layout at 1280x720.
        let lp = |x: i32, y: i32| LPARAM(((y as isize) << 16) | (x as isize & 0xffff));
        let post = |msg: u32, x: i32, y: i32| {
            let _ = PostMessageW(hwnd, msg, WPARAM((msg == WM_LBUTTONDOWN) as usize), lp(x, y));
        };
        let click = |x: i32, y: i32| {
            post(WM_MOUSEMOVE, x, y);
            post(WM_LBUTTONDOWN, x, y);
            post(WM_LBUTTONUP, x, y);
        };
        let script: &[(u128, &dyn Fn())] = &[
            (1000, &|| click(1018, 416)), // admin: right click -> trunk
            (1100, &|| post(WM_MOUSEMOVE, 1000, 232)), // onto the admin title bar
            (1200, &|| post(WM_LBUTTONDOWN, 1000, 232)),
            (1300, &|| post(WM_MOUSEMOVE, 900, 272)),
            (1400, &|| post(WM_MOUSEMOVE, 800, 312)),
            (1500, &|| post(WM_MOUSEMOVE, 700, 352)),
            (1600, &|| post(WM_LBUTTONUP, 700, 352)),
            (1800, &|| click(570, 198)),  // teleport: dasa
            (2000, &|| click(760, 194)),  // emote: Wave
            (2200, &|| click(200, 650)),  // empty screen: must reach the game
            (2400, &|| {
                let _ = PostMessageW(hwnd, WM_KEYDOWN, WPARAM(VK_TAB.0 as usize), LPARAM(1));
                let _ = PostMessageW(hwnd, WM_KEYUP, WPARAM(VK_TAB.0 as usize), LPARAM(1 | (1 << 30) | (1 << 31)));
            }),
        ];
        let t = start.elapsed().as_millis();
        while step < script.len() && t >= script[step].0 {
            (script[step].1)();
            step += 1;
        }

        // The "game" frame: clear to a road-grey so the panel stands out.
        let back: ID3D11Texture2D = swapchain.GetBuffer(0)?;
        let mut rtv = None;
        device.CreateRenderTargetView(&back, None, Some(&mut rtv))?;
        context.ClearRenderTargetView(rtv.as_ref().unwrap(), &[0.25, 0.27, 0.3, 1.0]);
        context.OMSetRenderTargets(Some(&[rtv.clone()]), None);
        drop(rtv);
        drop(back);

        if start.elapsed() > Duration::from_millis(2800) {
            // The hook draws into the back buffer before calling the real
            // Present; DXGI_PRESENT_TEST makes that real Present a no-op, so
            // the overlay is left in the buffer for us to read.
            let _ = swapchain.Present(0, DXGI_PRESENT_TEST);
            save_bmp(&device, &context, &swapchain.GetBuffer(0)?, "target/harness.bmp")?;
            println!("wrote target/harness.bmp");
            break;
        }
        swapchain.Present(1, DXGI_PRESENT(0)).ok()?;
    }

    println!(
        "game saw {} click(s) in total (want 1: only the empty-screen one)",
        GAME_CLICKS.load(std::sync::atomic::Ordering::Relaxed)
    );
    println!("final response: {}", poll("").trim());
    println!(
        "layout: {}",
        std::fs::read_to_string(&layout).unwrap_or_else(|_| "(none saved)".into()).replace(['\n', ' '], "")
    );
    Ok(())
}

unsafe fn save_bmp(
    device: &ID3D11Device,
    context: &ID3D11DeviceContext,
    tex: &ID3D11Texture2D,
    path: &str,
) -> Result<()> {
    let mut desc = D3D11_TEXTURE2D_DESC::default();
    tex.GetDesc(&mut desc);
    desc.Usage = D3D11_USAGE_STAGING;
    desc.BindFlags = 0;
    desc.CPUAccessFlags = D3D11_CPU_ACCESS_READ.0 as u32;
    desc.MiscFlags = 0;
    let mut staging = None;
    device.CreateTexture2D(&desc, None, Some(&mut staging))?;
    let staging = staging.unwrap();
    context.CopyResource(&staging, tex);
    let mut mapped = D3D11_MAPPED_SUBRESOURCE::default();
    context.Map(&staging, 0, D3D11_MAP_READ, 0, Some(&mut mapped))?;

    let (w, h) = (desc.Width as usize, desc.Height as usize);
    let mut out = Vec::with_capacity(54 + w * h * 4);
    let size = (54 + w * h * 4) as u32;
    out.extend_from_slice(b"BM");
    out.extend_from_slice(&size.to_le_bytes());
    out.extend_from_slice(&[0; 4]);
    out.extend_from_slice(&54u32.to_le_bytes());
    out.extend_from_slice(&40u32.to_le_bytes());
    out.extend_from_slice(&(w as i32).to_le_bytes());
    out.extend_from_slice(&(-(h as i32)).to_le_bytes()); // top-down
    out.extend_from_slice(&1u16.to_le_bytes());
    out.extend_from_slice(&32u16.to_le_bytes());
    out.extend_from_slice(&[0; 24]);
    for y in 0..h {
        let row = (mapped.pData as *const u8).add(y * mapped.RowPitch as usize);
        for x in 0..w {
            let p = row.add(x * 4);
            out.extend_from_slice(&[*p.add(2), *p.add(1), *p, 255]); // RGBA -> BGRA
        }
    }
    context.Unmap(&staging, 0);
    std::fs::write(path, out).unwrap();
    Ok(())
}
