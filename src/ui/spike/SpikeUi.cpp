// S1a spike — prove we can draw an ImGui window inside Motor Town.
//
// What this does, in order:
//   1. On a worker thread: create throwaway D3D11/D3D12 objects, read their
//      vtable pointers, and overwrite the two positions we care about
//      (IDXGISwapChain::Present, ID3D12CommandQueue::ExecuteCommandLists).
//      The vtables belong to dxgi.dll / d3d12.dll, so patching them affects the
//      game's swap-chain and queue as well.
//   2. On the first Present: initialise ImGui for whichever RHI is live,
//      subclass the game window's WndProc, and draw.
//   3. Insert toggles the window. Nothing here touches Unreal — that is S3/S4.
//
// Deliberately minimal: no panels, no HTTP, no Lua. If this renders stably the
// rest of the plan is viable.

#include "SpikeUi.h"

#include <windows.h>
#include <d3d11.h>
#include <d3d12.h>
#include <dxgi1_6.h>

#include <atomic>
#include <chrono>
#include <thread>

#include <imgui.h>
#include <imgui_impl_win32.h>
#include <imgui_impl_dx11.h>
#include <imgui_impl_dx12.h>

#include <DynamicOutput/DynamicOutput.hpp>

namespace
{
    using PFN_Present = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain*, UINT, UINT);
    using PFN_ResizeBuffers = HRESULT(STDMETHODCALLTYPE*)(IDXGISwapChain*, UINT, UINT, UINT, DXGI_FORMAT, UINT);
    using PFN_ExecuteCommandLists = void(STDMETHODCALLTYPE*)(ID3D12CommandQueue*, UINT, ID3D12CommandList* const*);

    PFN_Present g_origPresent = nullptr;
    PFN_ResizeBuffers g_origResizeBuffers = nullptr;
    PFN_ExecuteCommandLists g_origExecuteCommandLists = nullptr;

    // Captured from the game's first direct command queue (DX12 only).
    std::atomic<ID3D12CommandQueue*> g_gameQueue{nullptr};

    struct Renderer
    {
        enum class Api
        {
            None,
            D3D11,
            D3D12
        };

        Api api = Api::None;
        HWND hwnd = nullptr;
        WNDPROC origWndProc = nullptr;
        bool imguiWin32Ready = false;

        // D3D11
        ID3D11Device* dev11 = nullptr;
        ID3D11DeviceContext* ctx11 = nullptr;
        ID3D11RenderTargetView* rtv11 = nullptr;

        // D3D12
        ID3D12Device* dev12 = nullptr;
        ID3D12CommandQueue* queue12 = nullptr;
        ID3D12DescriptorHeap* rtvHeap = nullptr;
        ID3D12DescriptorHeap* srvHeap = nullptr;
        UINT rtvDescSize = 0;
        ID3D12Resource* backbuffers[8]{};
        D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle[8]{};
        UINT bufferCount = 0;
        DXGI_FORMAT format = DXGI_FORMAT_R8G8B8A8_UNORM;
        ID3D12CommandAllocator* alloc[2]{};
        ID3D12GraphicsCommandList* list = nullptr;
        ID3D12Fence* fence = nullptr;
        HANDLE fenceEvent = nullptr;
        UINT64 fenceValue = 0;
        UINT64 frameFence[2]{};
        UINT framesInFlight = 2;
    };

    Renderer g_r;

    bool g_open = true; // start open: a crash on the first frame should be immediate and logged
    bool g_keyHeld = false;
    double g_fpsAccum = 0.0;
    int g_fpsFrames = 0;
    int g_totalFrames = 0;
    bool g_loggedNoQueue = false;
    std::chrono::steady_clock::time_point g_lastFrame = std::chrono::steady_clock::now();

    // ---------------------------------------------------------------- helpers

    template <typename T>
    void SafeRelease(T*& p)
    {
        if (p)
        {
            p->Release();
            p = nullptr;
        }
    }

    bool PatchVtableEntry(void* object, size_t index, void* replacement, void** outOriginal)
    {
        if (!object)
        {
            return false;
        }
        void** vtable = *reinterpret_cast<void***>(object);
        if (!vtable)
        {
            return false;
        }

        DWORD oldProtect = 0;
        const SIZE_T size = sizeof(void*) * (index + 1);
        if (!VirtualProtect(vtable, size, PAGE_EXECUTE_READWRITE, &oldProtect))
        {
            return false;
        }
        if (outOriginal)
        {
            *outOriginal = vtable[index];
        }
        vtable[index] = replacement;
        VirtualProtect(vtable, size, oldProtect, &oldProtect);
        return true;
    }

    // ------------------------------------------------------------- WndProc

    LRESULT CALLBACK HookedWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
    {
        if (g_open && g_r.imguiWin32Ready)
        {
            if (ImGui_ImplWin32_WndProcHandler(hwnd, msg, wparam, lparam))
            {
                return 1;
            }
        }
        return CallWindowProcW(g_r.origWndProc, hwnd, msg, wparam, lparam);
    }

    void EnsureWindow(HWND hwnd)
    {
        if (!hwnd || g_r.hwnd == hwnd)
        {
            return;
        }
        g_r.hwnd = hwnd;
        g_r.origWndProc = reinterpret_cast<WNDPROC>(
            SetWindowLongPtrW(hwnd, GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(&HookedWndProc)));
        if (g_r.origWndProc)
        {
            RC::Output::send<RC::LogLevel::Default>(L"[spike] wndproc hooked hwnd={}\n",
                                                    reinterpret_cast<void*>(hwnd));
        }
    }

    // ------------------------------------------------------------- shutdown

    void ShutdownRenderTargets()
    {
        if (g_r.api == Renderer::Api::D3D11)
        {
            ImGui_ImplDX11_Shutdown();
            SafeRelease(g_r.rtv11);
            SafeRelease(g_r.ctx11);
            SafeRelease(g_r.dev11);
        }
        else if (g_r.api == Renderer::Api::D3D12)
        {
            ImGui_ImplDX12_Shutdown();
            for (auto& bb : g_r.backbuffers)
            {
                SafeRelease(bb);
            }
            for (auto& a : g_r.alloc)
            {
                SafeRelease(a);
            }
            SafeRelease(g_r.list);
            SafeRelease(g_r.fence);
            if (g_r.fenceEvent)
            {
                CloseHandle(g_r.fenceEvent);
                g_r.fenceEvent = nullptr;
            }
            SafeRelease(g_r.rtvHeap);
            SafeRelease(g_r.srvHeap);
            SafeRelease(g_r.queue12);
            SafeRelease(g_r.dev12);
        }
        g_r.api = Renderer::Api::None;
        g_totalFrames = 0;
    }

    // ---------------------------------------------------------------- DX12

    bool InitDX12(IDXGISwapChain* swapchain, ID3D12Device* device, ID3D12CommandQueue* queue)
    {
        IDXGISwapChain3* sc3 = nullptr;
        if (FAILED(swapchain->QueryInterface(__uuidof(IDXGISwapChain3), reinterpret_cast<void**>(&sc3))))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: no IDXGISwapChain3\n");
            return false;
        }

        DXGI_SWAP_CHAIN_DESC1 desc1{};
        sc3->GetDesc1(&desc1);
        g_r.format = desc1.Format;
        g_r.bufferCount = desc1.BufferCount > 8 ? 8 : desc1.BufferCount;
        g_r.dev12 = device;
        g_r.dev12->AddRef();
        g_r.queue12 = queue;
        g_r.queue12->AddRef();

        D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc{};
        rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
        rtvHeapDesc.NumDescriptors = g_r.bufferCount;
        if (FAILED(g_r.dev12->CreateDescriptorHeap(&rtvHeapDesc, IID_PPV_ARGS(&g_r.rtvHeap))))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: rtv heap failed\n");
            return false;
        }
        g_r.rtvDescSize = g_r.dev12->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);

        D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc{};
        srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
        srvHeapDesc.NumDescriptors = 1;
        srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
        if (FAILED(g_r.dev12->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(&g_r.srvHeap))))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: srv heap failed\n");
            return false;
        }

        D3D12_CPU_DESCRIPTOR_HANDLE handle = g_r.rtvHeap->GetCPUDescriptorHandleForHeapStart();
        for (UINT i = 0; i < g_r.bufferCount; ++i)
        {
            if (FAILED(sc3->GetBuffer(i, IID_PPV_ARGS(&g_r.backbuffers[i]))))
            {
                RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: GetBuffer({}) failed\n", i);
                return false;
            }
            g_r.rtvHandle[i] = handle;
            g_r.dev12->CreateRenderTargetView(g_r.backbuffers[i], nullptr, handle);
            handle.ptr += g_r.rtvDescSize;
        }

        for (UINT i = 0; i < g_r.framesInFlight; ++i)
        {
            if (FAILED(g_r.dev12->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT,
                                                         IID_PPV_ARGS(&g_r.alloc[i]))))
            {
                RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: allocator failed\n");
                return false;
            }
        }
        if (FAILED(g_r.dev12->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, g_r.alloc[0], nullptr,
                                                IID_PPV_ARGS(&g_r.list))))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: command list failed\n");
            return false;
        }
        g_r.list->Close();

        if (FAILED(g_r.dev12->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&g_r.fence))))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: fence failed\n");
            return false;
        }
        g_r.fenceEvent = CreateEventW(nullptr, FALSE, FALSE, nullptr);

        g_r.api = Renderer::Api::D3D12;

        if (!ImGui_ImplDX12_Init(g_r.dev12,
                                 static_cast<int>(g_r.framesInFlight),
                                 g_r.format,
                                 g_r.srvHeap,
                                 g_r.srvHeap->GetCPUDescriptorHandleForHeapStart(),
                                 g_r.srvHeap->GetGPUDescriptorHandleForHeapStart()))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12: ImGui_ImplDX12_Init failed\n");
            return false;
        }

        RC::Output::send<RC::LogLevel::Default>(L"[spike] DX12 backend ready (buffers={}, format={})\n",
                                                g_r.bufferCount,
                                                static_cast<int>(g_r.format));
        SafeRelease(sc3);
        return true;
    }

    void RenderDX12(IDXGISwapChain* swapchain)
    {
        IDXGISwapChain3* sc3 = nullptr;
        if (FAILED(swapchain->QueryInterface(__uuidof(IDXGISwapChain3), reinterpret_cast<void**>(&sc3))))
        {
            return;
        }

        const UINT index = sc3->GetCurrentBackBufferIndex();
        if (index >= g_r.bufferCount)
        {
            SafeRelease(sc3);
            return;
        }
        const UINT slot = index % g_r.framesInFlight;

        // Wait for the frame that used this allocator slot.
        if (g_r.frameFence[slot] != 0 && g_r.fence->GetCompletedValue() < g_r.frameFence[slot])
        {
            g_r.fence->SetEventOnCompletion(g_r.frameFence[slot], g_r.fenceEvent);
            WaitForSingleObject(g_r.fenceEvent, 1000);
        }

        g_r.alloc[slot]->Reset();
        g_r.list->Reset(g_r.alloc[slot], nullptr);

        ID3D12DescriptorHeap* heaps[] = {g_r.srvHeap};
        g_r.list->SetDescriptorHeaps(1, heaps);

        D3D12_RESOURCE_BARRIER barrier{};
        barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
        barrier.Transition.pResource = g_r.backbuffers[index];
        barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_PRESENT;
        barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET;
        barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
        g_r.list->ResourceBarrier(1, &barrier);

        g_r.list->OMSetRenderTargets(1, &g_r.rtvHandle[index], FALSE, nullptr);
        ImGui_ImplDX12_RenderDrawData(ImGui::GetDrawData(), g_r.list);

        barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
        barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_PRESENT;
        g_r.list->ResourceBarrier(1, &barrier);

        g_r.list->Close();
        ID3D12CommandList* lists[] = {g_r.list};
        g_r.queue12->ExecuteCommandLists(1, lists);
        if (FAILED(g_r.queue12->Signal(g_r.fence, ++g_r.fenceValue)))
        {
            RC::Output::send<RC::LogLevel::Warning>(L"[spike] DX12: fence signal failed\n");
        }
        g_r.frameFence[slot] = g_r.fenceValue;

        SafeRelease(sc3);
    }

    // ---------------------------------------------------------------- DX11

    bool InitDX11(IDXGISwapChain* swapchain, ID3D11Device* device)
    {
        g_r.dev11 = device;
        g_r.dev11->AddRef();
        g_r.dev11->GetImmediateContext(&g_r.ctx11);

        ID3D11Texture2D* backbuffer = nullptr;
        if (FAILED(swapchain->GetBuffer(0, IID_PPV_ARGS(&backbuffer))))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX11: GetBuffer(0) failed\n");
            return false;
        }
        const HRESULT hr = g_r.dev11->CreateRenderTargetView(backbuffer, nullptr, &g_r.rtv11);
        SafeRelease(backbuffer);
        if (FAILED(hr))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX11: CreateRenderTargetView failed\n");
            return false;
        }

        if (!ImGui_ImplDX11_Init(g_r.dev11, g_r.ctx11))
        {
            RC::Output::send<RC::LogLevel::Error>(L"[spike] DX11: ImGui_ImplDX11_Init failed\n");
            return false;
        }

        g_r.api = Renderer::Api::D3D11;
        RC::Output::send<RC::LogLevel::Default>(L"[spike] DX11 backend ready\n");
        return true;
    }

    void RenderDX11()
    {
        g_r.ctx11->OMSetRenderTargets(1, &g_r.rtv11, nullptr);
        ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
    }

    // ------------------------------------------------------------ the frame

    void EnsureImGui(IDXGISwapChain* swapchain)
    {
        DXGI_SWAP_CHAIN_DESC desc{};
        if (FAILED(swapchain->GetDesc(&desc)))
        {
            return;
        }
        EnsureWindow(desc.OutputWindow);

        if (!g_r.imguiWin32Ready)
        {
            if (!ImGui::GetCurrentContext())
            {
                ImGui::CreateContext();
                ImGuiIO& io = ImGui::GetIO();
                io.IniFilename = nullptr; // spike: no stray imgui.ini next to the exe
                io.LogFilename = nullptr;
            }
            if (ImGui_ImplWin32_Init(desc.OutputWindow))
            {
                g_r.imguiWin32Ready = true;
                RC::Output::send<RC::LogLevel::Default>(L"[spike] win32 backend ready\n");
            }
        }

        if (g_r.api != Renderer::Api::None)
        {
            return;
        }

        ID3D12Device* device12 = nullptr;
        if (SUCCEEDED(swapchain->GetDevice(__uuidof(ID3D12Device), reinterpret_cast<void**>(&device12))))
        {
            ID3D12CommandQueue* queue = g_gameQueue.load();
            if (!queue)
            {
                if (!g_loggedNoQueue)
                {
                    g_loggedNoQueue = true;
                    RC::Output::send<RC::LogLevel::Warning>(
                        L"[spike] DX12 present seen before a direct queue was captured — will retry\n");
                }
                device12->Release();
                return;
            }
            const bool ok = InitDX12(swapchain, device12, queue);
            device12->Release();
            if (!ok)
            {
                RC::Output::send<RC::LogLevel::Error>(L"[spike] DX12 init failed\n");
            }
            return;
        }

        ID3D11Device* device11 = nullptr;
        if (SUCCEEDED(swapchain->GetDevice(__uuidof(ID3D11Device), reinterpret_cast<void**>(&device11))))
        {
            const bool ok = InitDX11(swapchain, device11);
            device11->Release();
            if (!ok)
            {
                RC::Output::send<RC::LogLevel::Error>(L"[spike] DX11 init failed\n");
            }
            return;
        }

        RC::Output::send<RC::LogLevel::Error>(L"[spike] could not identify the RHI from the swap chain\n");
    }

    void DrawFrame(IDXGISwapChain* swapchain)
    {
        ImGuiIO& io = ImGui::GetIO();
        io.MouseDrawCursor = g_open;

        ImGui_ImplWin32_NewFrame();
        if (g_r.api == Renderer::Api::D3D12)
        {
            ImGui_ImplDX12_NewFrame();
        }
        else
        {
            ImGui_ImplDX11_NewFrame();
        }
        ImGui::NewFrame();

        ImGui::SetNextWindowSize(ImVec2(900.0f, 500.0f), ImGuiCond_FirstUseEver);
        ImGui::Begin("AMC spike — S1a");
        ImGui::Text("RHI: %s", g_r.api == Renderer::Api::D3D12 ? "D3D12" : "D3D11");
        ImGui::Text("frames: %d   fps: %.1f", g_totalFrames, io.Framerate);
        ImGui::Text("Insert toggles this window");
        ImGui::Separator();
        static char buffer[256] = "";
        if (ImGui::InputText("type here", buffer, sizeof(buffer)))
        {
            // no-op — S3 measures whether these keystrokes leak to the game
        }
        ImGui::Text("typed: %s", buffer);
        ImGui::End();

        ImGui::Render();

        if (g_r.api == Renderer::Api::D3D12)
        {
            RenderDX12(swapchain);
        }
        else
        {
            RenderDX11();
        }
        ++g_totalFrames;
    }

    void PresentBody(IDXGISwapChain* swapchain)
    {
        const bool down = (GetAsyncKeyState(VK_INSERT) & 0x8000) != 0;
        if (down && !g_keyHeld)
        {
            g_open = !g_open;
            RC::Output::send<RC::LogLevel::Default>(L"[spike] overlay {}\n", g_open ? L"OPEN" : L"CLOSED");
        }
        g_keyHeld = down;

        EnsureImGui(swapchain);
        if (g_open && g_r.api != Renderer::Api::None && g_r.imguiWin32Ready)
        {
            DrawFrame(swapchain);
        }

        // fps roll-up measured on our own clock (io.DeltaTime is stale while closed)
        if (g_r.api != Renderer::Api::None)
        {
            const auto now = std::chrono::steady_clock::now();
            const double dt = std::chrono::duration<double>(now - g_lastFrame).count();
            g_lastFrame = now;
            if (dt > 0.0 && dt < 1.0)
            {
                g_fpsAccum += dt;
                ++g_fpsFrames;
            }
            if (g_fpsAccum >= 10.0)
            {
                RC::Output::send<RC::LogLevel::Default>(L"[spike] fps~{:.1f} frames={}\n",
                                                        static_cast<double>(g_fpsFrames) / g_fpsAccum,
                                                        g_totalFrames);
                g_fpsAccum = 0.0;
                g_fpsFrames = 0;
            }
        }
    }

    // Present detour. __try lives in a thin wrapper with no unwinding locals so
    // clang-cl accepts it.
    HRESULT STDMETHODCALLTYPE HookedPresent(IDXGISwapChain* swapchain, UINT syncInterval, UINT flags)
    {
        __try
        {
            PresentBody(swapchain);
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            static bool logged = false;
            if (!logged)
            {
                logged = true;
                RC::Output::send<RC::LogLevel::Error>(
                    L"[spike] exception in present detour — overlay disabled\n");
            }
            g_open = false;
        }

        return g_origPresent(swapchain, syncInterval, flags);
    }

    HRESULT STDMETHODCALLTYPE HookedResizeBuffers(IDXGISwapChain* swapchain,
                                                  UINT bufferCount,
                                                  UINT width,
                                                  UINT height,
                                                  DXGI_FORMAT newFormat,
                                                  UINT flags)
    {
        RC::Output::send<RC::LogLevel::Default>(L"[spike] ResizeBuffers {}x{}\n", width, height);
        if (g_r.api != Renderer::Api::None)
        {
            ShutdownRenderTargets();
        }
        return g_origResizeBuffers(swapchain, bufferCount, width, height, newFormat, flags);
    }

    void STDMETHODCALLTYPE HookedExecuteCommandLists(ID3D12CommandQueue* queue,
                                                     UINT count,
                                                     ID3D12CommandList* const* lists)
    {
        if (!g_gameQueue.load())
        {
            D3D12_COMMAND_QUEUE_DESC desc{};
            if (SUCCEEDED(queue->GetDesc(&desc)) && desc.Type == D3D12_COMMAND_LIST_TYPE_DIRECT)
            {
                queue->AddRef();
                g_gameQueue.store(queue);
                RC::Output::send<RC::LogLevel::Default>(L"[spike] captured DX12 direct queue\n");
            }
        }
        g_origExecuteCommandLists(queue, count, lists);
    }

    // --------------------------------------------------------------- install

    bool InstallHooks()
    {
        // D3D12 queue vtable (execute command lists = index 10 on ID3D12CommandQueue)
        {
            ID3D12Device* device = nullptr;
            if (SUCCEEDED(D3D12CreateDevice(nullptr, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&device))))
            {
                D3D12_COMMAND_QUEUE_DESC desc{};
                desc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;
                ID3D12CommandQueue* queue = nullptr;
                if (SUCCEEDED(device->CreateCommandQueue(&desc, IID_PPV_ARGS(&queue))))
                {
                    const bool ok = PatchVtableEntry(queue, 10,
                                                     reinterpret_cast<void*>(&HookedExecuteCommandLists),
                                                     reinterpret_cast<void**>(&g_origExecuteCommandLists));
                    RC::Output::send<RC::LogLevel::Default>(L"[spike] ExecuteCommandLists hook: {}\n",
                                                            ok ? "ok" : "FAILED");
                    queue->Release();
                }
                device->Release();
            }
            else
            {
                RC::Output::send<RC::LogLevel::Warning>(L"[spike] D3D12CreateDevice failed (DX11-only machine?)\n");
            }
        }

        // DXGI swap chain vtable, taken from a throwaway D3D11 swap chain
        {
            WNDCLASSEXW wc{};
            wc.cbSize = sizeof(wc);
            wc.lpfnWndProc = DefWindowProcW;
            wc.hInstance = GetModuleHandleW(nullptr);
            wc.lpszClassName = L"SpikeDummyWindow";
            RegisterClassExW(&wc);
            HWND hwnd = CreateWindowExW(0, wc.lpszClassName, L"", WS_OVERLAPPEDWINDOW, 0, 0, 8, 8, nullptr, nullptr,
                                        wc.hInstance, nullptr);

            DXGI_SWAP_CHAIN_DESC desc{};
            desc.BufferCount = 1;
            desc.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
            desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
            desc.OutputWindow = hwnd;
            desc.SampleDesc.Count = 1;
            desc.Windowed = TRUE;
            desc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;

            ID3D11Device* device = nullptr;
            ID3D11DeviceContext* context = nullptr;
            IDXGISwapChain* swapchain = nullptr;
            const HRESULT hr = D3D11CreateDeviceAndSwapChain(
                nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, 0, nullptr, 0, D3D11_SDK_VERSION, &desc, &swapchain,
                &device, nullptr, &context);

            bool ok = false;
            if (SUCCEEDED(hr) && swapchain)
            {
                ok = PatchVtableEntry(swapchain, 8, reinterpret_cast<void*>(&HookedPresent),
                                      reinterpret_cast<void**>(&g_origPresent)) &&
                     PatchVtableEntry(swapchain, 13, reinterpret_cast<void*>(&HookedResizeBuffers),
                                      reinterpret_cast<void**>(&g_origResizeBuffers));
            }
            RC::Output::send<RC::LogLevel::Default>(L"[spike] Present/ResizeBuffers hook: {}\n",
                                                    ok ? "ok" : "FAILED");

            SafeRelease(swapchain);
            SafeRelease(context);
            SafeRelease(device);
            if (hwnd)
            {
                DestroyWindow(hwnd);
            }
            UnregisterClassW(wc.lpszClassName, wc.hInstance);
            return ok;
        }
    }
} // namespace

namespace SpikeUi
{
    void Start()
    {
        std::thread([] {
            const bool ok = InstallHooks();
            RC::Output::send<RC::LogLevel::Default>(L"[spike] install {}\n", ok ? "complete" : "FAILED");
        }).detach();
    }

    void Stop()
    {
        ShutdownRenderTargets();
        if (g_r.imguiWin32Ready)
        {
            ImGui_ImplWin32_Shutdown();
            g_r.imguiWin32Ready = false;
        }
        if (ImGui::GetCurrentContext())
        {
            ImGui::DestroyContext();
        }
        if (g_r.hwnd && g_r.origWndProc)
        {
            SetWindowLongPtrW(g_r.hwnd, GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(g_r.origWndProc));
            g_r.hwnd = nullptr;
            g_r.origWndProc = nullptr;
        }
    }
} // namespace SpikeUi
