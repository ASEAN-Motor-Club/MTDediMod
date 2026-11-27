//! Minimal egui renderer for D3D12.
//!
//! Draws into the game's back buffer just before Present. We own a private
//! command allocator + list, so none of the game's command-list state is
//! touched; the one thing we share is the swapchain's presenting command
//! queue (captured by the `ExecuteCommandLists` hook in hook.rs) — executing
//! on that same queue guarantees our draws are ordered before the Present.
//!
//! Synchronisation: after each frame's list is executed we signal a fence and
//! wait for it before returning, so the game's next frame starts with all our
//! work finished and the allocator safe to reset. Upload-heap buffers are
//! rewritten only after that wait, never while the GPU may still read them.

use std::collections::HashMap;
use std::ffi::c_void;
use std::mem::ManuallyDrop;
use std::sync::atomic::{AtomicBool, Ordering};

use egui::epaint::{ClippedPrimitive, ImageData, Primitive, Vertex};
use egui::{TextureId, TexturesDelta};
use windows::core::{s, Error, Interface, PCSTR, Result};
use windows::Win32::Foundation::{CloseHandle, E_FAIL, HANDLE, RECT};
use windows::Win32::Graphics::Direct3D::Fxc::D3DCompile;
use windows::Win32::Graphics::Direct3D::{ID3DBlob, D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST};
use windows::Win32::Graphics::Direct3D12::*;
use windows::Win32::Graphics::Dxgi::Common::*;
use windows::Win32::Graphics::Dxgi::IDXGISwapChain;
use windows::Win32::System::Threading::{CreateEventW, WaitForSingleObject, INFINITE};

const SHADER: &str = include_str!("shader.hlsl");
/// Shader-visible SRV slots for egui font/image textures.
const SRV_HEAP_CAP: u32 = 256;
/// RTV slots for the swapchain's back buffers.
const RTV_HEAP_CAP: u32 = 8;

struct Texture {
    resource: ID3D12Resource,
    /// Index into the SRV descriptor heap.
    slot: u32,
}

/// One staged texture copy for the frame in progress.
struct StagedCopy {
    resource: ID3D12Resource,
    /// None = whole-texture copy for a freshly created resource (currently in
    /// COPY_DEST). Some(box) = partial update (currently in SRV state).
    sub_box: Option<D3D12_BOX>,
    upload_offset: u64,
    width: u32,
    height: u32,
}

pub struct Painter {
    device: ID3D12Device,
    allocator: ID3D12CommandAllocator,
    list: ID3D12GraphicsCommandList,
    root_sig: ID3D12RootSignature,
    pso: ID3D12PipelineState,
    format: DXGI_FORMAT,
    rtv_start: D3D12_CPU_DESCRIPTOR_HANDLE,
    rtv_step: u32,
    fence: ID3D12Fence,
    fence_event: HANDLE,
    fence_value: u64,
    rtv_heap: ID3D12DescriptorHeap,
    rtv_count: u32,
    srv_heap: ID3D12DescriptorHeap,
    srv_start_cpu: D3D12_CPU_DESCRIPTOR_HANDLE,
    srv_start_gpu: D3D12_GPU_DESCRIPTOR_HANDLE,
    srv_handle_size: u32,
    next_srv_slot: u32,
    free_srv: Vec<u32>,
    /// (resource, persistent CPU pointer, capacity) — vertices/indices are
    /// drawn directly out of the upload heap, no per-frame copy needed.
    vbuf: Option<(ID3D12Resource, *mut u8, usize)>,
    ibuf: Option<(ID3D12Resource, *mut u8, usize)>,
    /// Staging buffer for this frame's texture updates.
    tex_upload: Option<(ID3D12Resource, *mut u8, usize)>,
    stage_offset: u64,
    staged: Vec<StagedCopy>,
    textures: HashMap<TextureId, Texture>,
    /// Back-buffer size; RTVs live in `rtv_heap` slots 0..rtv_count.
    target: Option<(u32, u32)>,
}

fn fail(msg: &str) -> Error {
    Error::new(E_FAIL, msg)
}

unsafe fn compile(entry: PCSTR, target: PCSTR) -> Result<ID3DBlob> {
    let mut code = None;
    let mut errors = None;
    let r = D3DCompile(
        SHADER.as_ptr() as *const c_void,
        SHADER.len(),
        PCSTR::null(),
        None,
        None,
        entry,
        target,
        0,
        0,
        &mut code,
        Some(&mut errors),
    );
    if let Err(e) = r {
        if let Some(blob) = errors {
            let msg = std::slice::from_raw_parts(
                blob.GetBufferPointer() as *const u8,
                blob.GetBufferSize(),
            );
            return Err(Error::new(e.code(), String::from_utf8_lossy(msg).to_string()));
        }
        return Err(e);
    }
    code.ok_or_else(|| fail("D3DCompile returned no code"))
}

unsafe fn blob_bytes(blob: &ID3DBlob) -> &[u8] {
    std::slice::from_raw_parts(blob.GetBufferPointer() as *const u8, blob.GetBufferSize())
}

/// Matches egui::epaint::Vertex: pos [f32;2], uv [f32;2], color [u8;4].
fn input_elements() -> [D3D12_INPUT_ELEMENT_DESC; 3] {
    [
        D3D12_INPUT_ELEMENT_DESC {
            SemanticName: s!("POSITION"),
            SemanticIndex: 0,
            Format: DXGI_FORMAT_R32G32_FLOAT,
            InputSlot: 0,
            AlignedByteOffset: 0,
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA,
            InstanceDataStepRate: 0,
        },
        D3D12_INPUT_ELEMENT_DESC {
            SemanticName: s!("TEXCOORD"),
            SemanticIndex: 0,
            Format: DXGI_FORMAT_R32G32_FLOAT,
            InputSlot: 0,
            AlignedByteOffset: 8,
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA,
            InstanceDataStepRate: 0,
        },
        D3D12_INPUT_ELEMENT_DESC {
            SemanticName: s!("COLOR"),
            SemanticIndex: 0,
            Format: DXGI_FORMAT_R8G8B8A8_UNORM,
            InputSlot: 0,
            AlignedByteOffset: 16,
            InputSlotClass: D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA,
            InstanceDataStepRate: 0,
        },
    ]
}

/// Rebuild the PSO when the swapchain's RTV format is not the default one.
unsafe fn make_pso(
    device: &ID3D12Device,
    root_sig: &ID3D12RootSignature,
    format: DXGI_FORMAT,
) -> Result<ID3D12PipelineState> {
    // Same shader source as D3D11, compiled for SM 5.0.
    let vs_blob = compile(s!("vs_main"), s!("vs_5_0"))?;
    let ps_blob = compile(s!("ps_main"), s!("ps_5_0"))?;
    let elements = input_elements();

    // egui emits premultiplied alpha (same blend as the D3D11 path).
    let rt_blend = D3D12_RENDER_TARGET_BLEND_DESC {
        BlendEnable: true.into(),
        LogicOpEnable: false.into(),
        SrcBlend: D3D12_BLEND_ONE,
        DestBlend: D3D12_BLEND_INV_SRC_ALPHA,
        BlendOp: D3D12_BLEND_OP_ADD,
        SrcBlendAlpha: D3D12_BLEND_INV_DEST_ALPHA,
        DestBlendAlpha: D3D12_BLEND_ONE,
        BlendOpAlpha: D3D12_BLEND_OP_ADD,
        LogicOp: D3D12_LOGIC_OP_NOOP,
        RenderTargetWriteMask: D3D12_COLOR_WRITE_ENABLE_ALL.0 as u8,
    };
    let vs_bytes = blob_bytes(&vs_blob);
    let ps_bytes = blob_bytes(&ps_blob);
    let mut rtv_formats = [DXGI_FORMAT_UNKNOWN; 8];
    rtv_formats[0] = format;
    let pso_desc = D3D12_GRAPHICS_PIPELINE_STATE_DESC {
        pRootSignature: ManuallyDrop::new(Some(root_sig.clone())),
        VS: D3D12_SHADER_BYTECODE {
            pShaderBytecode: vs_bytes.as_ptr() as *const c_void,
            BytecodeLength: vs_bytes.len(),
        },
        PS: D3D12_SHADER_BYTECODE {
            pShaderBytecode: ps_bytes.as_ptr() as *const c_void,
            BytecodeLength: ps_bytes.len(),
        },
        InputLayout: D3D12_INPUT_LAYOUT_DESC {
            pInputElementDescs: elements.as_ptr(),
            NumElements: elements.len() as u32,
        },
        BlendState: D3D12_BLEND_DESC {
            AlphaToCoverageEnable: false.into(),
            IndependentBlendEnable: false.into(),
            RenderTarget: [rt_blend; 8],
        },
        SampleMask: u32::MAX,
        RasterizerState: D3D12_RASTERIZER_DESC {
            FillMode: D3D12_FILL_MODE_SOLID,
            CullMode: D3D12_CULL_MODE_NONE,
            FrontCounterClockwise: false.into(),
            DepthBias: 0,
            DepthBiasClamp: 0.0,
            SlopeScaledDepthBias: 0.0,
            DepthClipEnable: true.into(),
            MultisampleEnable: false.into(),
            AntialiasedLineEnable: false.into(),
            ForcedSampleCount: 0,
            ConservativeRaster: D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF,
        },
        DepthStencilState: D3D12_DEPTH_STENCIL_DESC {
            DepthEnable: false.into(),
            StencilEnable: false.into(),
            ..Default::default()
        },
        PrimitiveTopologyType: D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE,
        NumRenderTargets: 1,
        RTVFormats: rtv_formats,
        SampleDesc: DXGI_SAMPLE_DESC { Count: 1, Quality: 0 },
        ..Default::default()
    };
    device.CreateGraphicsPipelineState(&pso_desc)
}

impl Painter {
    pub unsafe fn new(device: &ID3D12Device) -> Result<Self> {
        let device = device.clone();

        // Root signature: b0 as 2 root constants (screen size in points) +
        // t0 as a one-descriptor table + a static linear clamp sampler.
        let ranges = [D3D12_DESCRIPTOR_RANGE {
            RangeType: D3D12_DESCRIPTOR_RANGE_TYPE_SRV,
            NumDescriptors: 1,
            BaseShaderRegister: 0,
            RegisterSpace: 0,
            OffsetInDescriptorsFromTableStart: 0,
        }];
        let params = [
            D3D12_ROOT_PARAMETER {
                ParameterType: D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS,
                Anonymous: D3D12_ROOT_PARAMETER_0 {
                    Constants: D3D12_ROOT_CONSTANTS {
                        ShaderRegister: 0,
                        RegisterSpace: 0,
                        Num32BitValues: 4,
                    },
                },
                ShaderVisibility: D3D12_SHADER_VISIBILITY_VERTEX,
            },
            D3D12_ROOT_PARAMETER {
                ParameterType: D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE,
                Anonymous: D3D12_ROOT_PARAMETER_0 {
                    DescriptorTable: D3D12_ROOT_DESCRIPTOR_TABLE {
                        NumDescriptorRanges: 1,
                        pDescriptorRanges: ranges.as_ptr(),
                    },
                },
                ShaderVisibility: D3D12_SHADER_VISIBILITY_PIXEL,
            },
        ];
        let samplers = [D3D12_STATIC_SAMPLER_DESC {
            Filter: D3D12_FILTER_MIN_MAG_MIP_LINEAR,
            AddressU: D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
            AddressV: D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
            AddressW: D3D12_TEXTURE_ADDRESS_MODE_CLAMP,
            MipLODBias: 0.0,
            MaxAnisotropy: 0,
            ComparisonFunc: D3D12_COMPARISON_FUNC_ALWAYS,
            BorderColor: D3D12_STATIC_BORDER_COLOR_TRANSPARENT_BLACK,
            MinLOD: 0.0,
            MaxLOD: f32::MAX,
            ShaderRegister: 0,
            RegisterSpace: 0,
            ShaderVisibility: D3D12_SHADER_VISIBILITY_PIXEL,
        }];
        let rs_desc = D3D12_ROOT_SIGNATURE_DESC {
            NumParameters: params.len() as u32,
            pParameters: params.as_ptr(),
            NumStaticSamplers: samplers.len() as u32,
            pStaticSamplers: samplers.as_ptr(),
            Flags: D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT,
        };
        let mut rs_blob: Option<ID3DBlob> = None;
        D3D12SerializeRootSignature(&rs_desc, D3D_ROOT_SIGNATURE_VERSION_1, &mut rs_blob, None)?;
        let rs_blob = rs_blob.ok_or_else(|| fail("no root signature blob"))?;
        let root_sig: ID3D12RootSignature =
            device.CreateRootSignature(0, blob_bytes(&rs_blob))?;

        let pso = make_pso(&device, &root_sig, DXGI_FORMAT_R8G8B8A8_UNORM)?;

        let allocator: ID3D12CommandAllocator =
            device.CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT)?;
        let list: ID3D12GraphicsCommandList =
            device.CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, &allocator, Some(&pso))?;
        // Close it now: Reset (in draw) requires a closed list.
        list.Close()?;

        let fence: ID3D12Fence = device.CreateFence(0, D3D12_FENCE_FLAG_NONE)?;
        let fence_event = CreateEventW(None, false, false, None)?;

        let rtv_desc = D3D12_DESCRIPTOR_HEAP_DESC {
            Type: D3D12_DESCRIPTOR_HEAP_TYPE_RTV,
            NumDescriptors: RTV_HEAP_CAP,
            Flags: D3D12_DESCRIPTOR_HEAP_FLAG_NONE,
            NodeMask: 0,
        };
        let rtv_heap: ID3D12DescriptorHeap = device.CreateDescriptorHeap(&rtv_desc)?;

        let srv_desc = D3D12_DESCRIPTOR_HEAP_DESC {
            Type: D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV,
            NumDescriptors: SRV_HEAP_CAP,
            Flags: D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE,
            NodeMask: 0,
        };
        let srv_heap: ID3D12DescriptorHeap = device.CreateDescriptorHeap(&srv_desc)?;
        let srv_start_cpu = srv_heap.GetCPUDescriptorHandleForHeapStart();
        let srv_start_gpu = srv_heap.GetGPUDescriptorHandleForHeapStart();
        let srv_handle_size =
            device.GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);

        Ok(Self {
            device,
            allocator,
            list,
            root_sig,
            pso,
            format: DXGI_FORMAT_R8G8B8A8_UNORM,
            rtv_start: D3D12_CPU_DESCRIPTOR_HANDLE { ptr: 0 },
            rtv_step: 0,
            fence,
            fence_event,
            fence_value: 0,
            rtv_heap,
            rtv_count: 0,
            srv_heap,
            srv_start_cpu,
            srv_start_gpu,
            srv_handle_size,
            next_srv_slot: 0,
            free_srv: Vec::new(),
            vbuf: None,
            ibuf: None,
            tex_upload: None,
            stage_offset: 0,
            staged: Vec::new(),
            textures: HashMap::new(),
            target: None,
        })
    }

    /// Drop our view of the back buffers (must happen before ResizeBuffers).
    ///
    /// We never hold references to the back-buffer resources (RTVs are baked
    /// straight into the descriptor heap from temporary GetBuffer results),
    /// so clearing the sizes is all that is needed.
    pub fn release_target(&mut self) {
        self.target = None;
        self.rtv_count = 0;
    }

    /// Bake RTVs for every back buffer into the RTV heap; returns the size.
    pub unsafe fn ensure_target(&mut self, swapchain: &IDXGISwapChain) -> Result<(u32, u32)> {
        if let Some((w, h)) = self.target {
            return Ok((w, h));
        }
        let desc = swapchain.GetDesc()?;
        let format = desc.BufferDesc.Format;
        if format != self.format {
            // The PSO's RTV format must match the swapchain exactly.
            self.pso = make_pso(&self.device, &self.root_sig, format)?;
            self.format = format;
        }
        let count = desc.BufferCount.min(RTV_HEAP_CAP);
        let rtv_start = self.rtv_heap.GetCPUDescriptorHandleForHeapStart();
        let rtv_step = self
            .device
            .GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
        self.rtv_start = rtv_start;
        self.rtv_step = rtv_step;
        let mut size = (0u32, 0u32);
        for i in 0..count {
            // GetBuffer returns a temporary reference we must not keep: it is
            // dropped at the end of each iteration, so ResizeBuffers is never
            // blocked by us.
            let buffer: ID3D12Resource = swapchain.GetBuffer(i)?;
            let handle = D3D12_CPU_DESCRIPTOR_HANDLE {
                ptr: rtv_start.ptr + (i as usize) * (rtv_step as usize),
            };
            self.device.CreateRenderTargetView(&buffer, None, handle);
            if i == 0 {
                let d = buffer.GetDesc();
                size = (d.Width as u32, d.Height as u32);
            }
        }
        if size.0 == 0 || size.1 == 0 {
            return Err(fail("bad back-buffer size"));
        }
        self.rtv_count = count;
        self.target = Some(size);
        Ok(size)
    }

    pub unsafe fn paint(
        &mut self,
        swapchain: &IDXGISwapChain,
        queue: Option<&ID3D12CommandQueue>,
        back_index: u32,
        primitives: &[ClippedPrimitive],
        delta: &TexturesDelta,
        pixels_per_point: f32,
    ) -> Result<()> {
        for (id, image) in &delta.set {
            self.update_texture(*id, image)?;
        }

        let Some(queue) = queue.cloned() else {
            if !WARNED_NO_QUEUE.swap(true, Ordering::Relaxed) {
                crate::log::warn("D3D12 command queue not captured yet; skipping frame");
            }
            return Ok(());
        };

        let result = self.draw(swapchain, &queue, back_index, primitives, pixels_per_point);

        // Free after drawing: this frame's meshes may still reference them.
        for id in &delta.free {
            if let Some(tex) = self.textures.remove(id) {
                self.free_srv.push(tex.slot);
            }
        }
        result
    }

    unsafe fn draw(
        &mut self,
        swapchain: &IDXGISwapChain,
        queue: &ID3D12CommandQueue,
        back_index: u32,
        primitives: &[ClippedPrimitive],
        ppp: f32,
    ) -> Result<()> {
        let Some((width, height)) = self.target else {
            return Ok(());
        };

        // Gather every mesh into one vertex/index upload.
        let mut vertices: Vec<Vertex> = Vec::new();
        let mut indices: Vec<u32> = Vec::new();
        let mut draws = Vec::new(); // (texture, clip, index offset, index count, vertex offset)
        for prim in primitives {
            let Primitive::Mesh(mesh) = &prim.primitive else {
                continue; // paint callbacks are not supported
            };
            if mesh.indices.is_empty() {
                continue;
            }
            draws.push((
                mesh.texture_id,
                prim.clip_rect,
                indices.len() as u32,
                mesh.indices.len() as u32,
                vertices.len() as i32,
            ));
            vertices.extend_from_slice(&mesh.vertices);
            indices.extend_from_slice(&mesh.indices);
        }
        if draws.is_empty() {
            self.staged.clear();
            self.stage_offset = 0;
            return Ok(());
        }

        // Borrow the active back buffer for this draw call only (dropped on
        // return so ResizeBuffers is never blocked by us).
        let index = back_index.min(self.rtv_count.saturating_sub(1));
        let backbuffer: ID3D12Resource = swapchain.GetBuffer(index)?;

        // Anything fallible below runs while a command list may already be
        // open; on error we still close/execute/wait so the allocator stays
        // usable and the game's queue is left with no dangling work.
        let opened = self.allocator.Reset().is_ok() && self.list.Reset(&self.allocator, Some(&self.pso)).is_ok();
        if !opened {
            self.staged.clear();
            self.stage_offset = 0;
            return Err(fail("command list reset failed"));
        }

        let result = self.record_frame(
            width,
            height,
            ppp,
            index,
            &backbuffer,
            &vertices,
            &indices,
            &draws,
        );

        // Close + execute + fence-wait on both success and error paths.
        match self.list.Close() {
            Ok(()) => {
                queue.ExecuteCommandLists(&[Some(self.list.cast::<ID3D12CommandList>()?)]);
                self.fence_value += 1;
                let value = self.fence_value;
                if queue.Signal(&self.fence, value).is_ok() && self.fence.GetCompletedValue() < value
                {
                    if self.fence.SetEventOnCompletion(value, self.fence_event).is_ok() {
                        WaitForSingleObject(self.fence_event, INFINITE);
                    }
                }
                static LOGGED_FIRST: AtomicBool = AtomicBool::new(false);
                if !LOGGED_FIRST.swap(true, Ordering::Relaxed) {
                    crate::log::info(&format!(
                        "D3D12 first frame rendered ({}x{}, {} draws, back_index={})",
                        width,
                        height,
                        draws.len(),
                        index
                    ));
                }
            }
            Err(_) => {
                // List never made it to the GPU: try to get the allocator
                // back for the next frame.
                let _ = self.allocator.Reset();
            }
        }

        self.staged.clear();
        self.stage_offset = 0;

        // Free after drawing: this frame's meshes may still reference them.
        result
    }

    /// Record everything for this frame into the (already reset) list.
    #[allow(clippy::too_many_arguments)]
    unsafe fn record_frame(
        &mut self,
        width: u32,
        height: u32,
        ppp: f32,
        index: u32,
        backbuffer: &ID3D12Resource,
        vertices: &[Vertex],
        indices: &[u32],
        draws: &[(TextureId, egui::Rect, u32, u32, i32)],
    ) -> Result<()> {
        self.list.SetGraphicsRootSignature(&self.root_sig);
        self.list.SetDescriptorHeaps(&[Some(self.srv_heap.clone())]);

        // Texture copies for this frame's staged updates.
        self.record_texture_copies();

        // Vertex/index data: straight out of upload-heap buffers (which stay
        // permanently in D3D12_RESOURCE_STATE_GENERIC_READ per D3D12 spec).
        let vview = self.write_buffer(true, bytes_of(vertices))?;
        let iview = self.write_buffer(false, bytes_of(indices))?;

        // At IDXGISwapChain::Present time the back buffer is in PRESENT state;
        // transition to RENDER_TARGET before drawing and back to PRESENT after.
        self.resource_barrier(
            backbuffer,
            D3D12_RESOURCE_STATE_PRESENT,
            D3D12_RESOURCE_STATE_RENDER_TARGET,
        );

        self.list.IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
        self.list.IASetVertexBuffers(
            0,
            Some(&[D3D12_VERTEX_BUFFER_VIEW {
                BufferLocation: vview.0,
                SizeInBytes: vview.1,
                StrideInBytes: std::mem::size_of::<Vertex>() as u32,
            }]),
        );
        self.list.IASetIndexBuffer(Some(&D3D12_INDEX_BUFFER_VIEW {
            BufferLocation: iview.0,
            SizeInBytes: iview.1,
            Format: DXGI_FORMAT_R32_UINT,
        }));
        self.list.RSSetViewports(&[D3D12_VIEWPORT {
            TopLeftX: 0.0,
            TopLeftY: 0.0,
            Width: width as f32,
            Height: height as f32,
            MinDepth: 0.0,
            MaxDepth: 1.0,
        }]);

        let rtv = D3D12_CPU_DESCRIPTOR_HANDLE {
            ptr: self.rtv_start.ptr + (index as usize) * (self.rtv_step as usize),
        };
        self.list.OMSetRenderTargets(1, Some(&rtv), false, None::<*const D3D12_CPU_DESCRIPTOR_HANDLE>);

        // Screen size in points for the vertex shader (16 bytes, b0).
        let cb = [width as f32 / ppp, height as f32 / ppp, 0.0, 0.0];
        self.list
            .SetGraphicsRoot32BitConstants(0, 4, cb.as_ptr() as *const c_void, 0);

        for (tex_id, clip, first, count, base) in draws {
            let Some(tex) = self.textures.get(tex_id) else {
                continue;
            };
            let left = (clip.min.x * ppp).round().clamp(0.0, width as f32) as i32;
            let top = (clip.min.y * ppp).round().clamp(0.0, height as f32) as i32;
            let right = (clip.max.x * ppp).round().clamp(0.0, width as f32) as i32;
            let bottom = (clip.max.y * ppp).round().clamp(0.0, height as f32) as i32;
            if right <= left || bottom <= top {
                continue;
            }
            self.list.RSSetScissorRects(&[RECT {
                left,
                top,
                right,
                bottom,
            }]);
            let gpu = D3D12_GPU_DESCRIPTOR_HANDLE {
                ptr: self.srv_start_gpu.ptr + (tex.slot as u64) * (self.srv_handle_size as u64),
            };
            self.list.SetGraphicsRootDescriptorTable(1, gpu);
            self.list.DrawIndexedInstanced(*count, 1, *first, *base, 0);
        }

        self.resource_barrier(
            backbuffer,
            D3D12_RESOURCE_STATE_RENDER_TARGET,
            D3D12_RESOURCE_STATE_PRESENT,
        );
        Ok(())
    }

    /// Record CopyTextureRegion (+ state barriers) for this frame's updates.
    unsafe fn record_texture_copies(&mut self) {
        for copy in self.staged.split_off(0) {
            let Some((up, _, _)) = &self.tex_upload else {
                continue;
            };
            let src = D3D12_TEXTURE_COPY_LOCATION {
                pResource: ManuallyDrop::new(Some(up.clone())),
                Type: D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT,
                Anonymous: D3D12_TEXTURE_COPY_LOCATION_0 {
                    PlacedFootprint: D3D12_PLACED_SUBRESOURCE_FOOTPRINT {
                        Offset: copy.upload_offset,
                        Footprint: D3D12_SUBRESOURCE_FOOTPRINT {
                            Format: DXGI_FORMAT_R8G8B8A8_UNORM,
                            Width: copy.width,
                            Height: copy.height,
                            Depth: 1,
                            RowPitch: (copy.width * 4).next_multiple_of(256),
                        },
                    },
                },
            };
            let dst = D3D12_TEXTURE_COPY_LOCATION {
                pResource: ManuallyDrop::new(Some(copy.resource.clone())),
                Type: D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX,
                Anonymous: D3D12_TEXTURE_COPY_LOCATION_0 { SubresourceIndex: 0 },
            };
            let whole = copy.sub_box.is_none();
            if let Some(box_) = &copy.sub_box {
                // Partial update: SRV state -> COPY_DEST, copy, back.
                self.resource_barrier(
                    &copy.resource,
                    D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE,
                    D3D12_RESOURCE_STATE_COPY_DEST,
                );
                self.list.CopyTextureRegion(&dst, 0, 0, 0, &src, Some(box_));
                self.resource_barrier(
                    &copy.resource,
                    D3D12_RESOURCE_STATE_COPY_DEST,
                    D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE,
                );
            } else {
                // New texture: created in COPY_DEST; copy, then make it
                // shader-readable.
                let _ = whole;
                self.list.CopyTextureRegion(&dst, 0, 0, 0, &src, None);
                self.resource_barrier(
                    &copy.resource,
                    D3D12_RESOURCE_STATE_COPY_DEST,
                    D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE,
                );
            }
        }
    }

    unsafe fn resource_barrier(
        &self,
        resource: &ID3D12Resource,
        before: D3D12_RESOURCE_STATES,
        after: D3D12_RESOURCE_STATES,
    ) {
        self.list.ResourceBarrier(&[D3D12_RESOURCE_BARRIER {
            Type: D3D12_RESOURCE_BARRIER_TYPE_TRANSITION,
            Flags: D3D12_RESOURCE_BARRIER_FLAG_NONE,
            Anonymous: D3D12_RESOURCE_BARRIER_0 {
                Transition: ManuallyDrop::new(D3D12_RESOURCE_TRANSITION_BARRIER {
                    pResource: ManuallyDrop::new(Some(resource.clone())),
                    StateBefore: before,
                    StateAfter: after,
                    Subresource: D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES,
                }),
            },
        }]);
    }

    /// Write `data` into the persistent upload buffer, growing it if needed.
    /// Returns (GPU address, size in bytes) for building the VB/IB views.
    unsafe fn write_buffer(&mut self, vertex: bool, data: &[u8]) -> Result<(u64, u32)> {
        let slot = if vertex {
            &mut self.vbuf
        } else {
            &mut self.ibuf
        };
        if slot.as_ref().map_or(true, |(_, _, cap)| *cap < data.len()) {
            let cap = data.len().next_power_of_two().max(64 * 1024);
            let mut res: Option<ID3D12Resource> = None;
            self.device.CreateCommittedResource(
                &upload_heap(),
                D3D12_HEAP_FLAG_NONE,
                &buffer_desc(cap as u64),
                D3D12_RESOURCE_STATE_GENERIC_READ,
                None,
                &mut res,
            )?;
            let res = res.ok_or_else(|| fail("no upload buffer"))?;
            let mut ptr = std::ptr::null_mut();
            res.Map(0, None, Some(&mut ptr))?;
            *slot = Some((res, ptr as *mut u8, cap));
        }
        let (res, ptr, _) = slot.as_ref().unwrap();
        std::ptr::copy_nonoverlapping(data.as_ptr(), *ptr, data.len());
        let gpu = res.GetGPUVirtualAddress();
        Ok((gpu, data.len() as u32))
    }

    unsafe fn update_texture(
        &mut self,
        id: TextureId,
        delta: &egui::epaint::ImageDelta,
    ) -> Result<()> {
        let (size, pixels): ([usize; 2], Vec<egui::Color32>) = match &delta.image {
            ImageData::Color(img) => (img.size, img.pixels.clone()),
            ImageData::Font(img) => (img.size, img.srgba_pixels(None).collect()),
        };
        let bytes = bytes_of(&pixels);

        if let Some(pos) = delta.pos {
            // Partial update (the font atlas grows this way).
            let (resource, _slot) = match self.textures.get(&id) {
                Some(tex) => (tex.resource.clone(), tex.slot),
                None => return Ok(()),
            };
            let off = self.stage_bytes(size[0], bytes)?;
            self.staged.push(StagedCopy {
                resource,
                sub_box: Some(D3D12_BOX {
                    left: pos[0] as u32,
                    top: pos[1] as u32,
                    front: 0,
                    right: (pos[0] + size[0]) as u32,
                    bottom: (pos[1] + size[1]) as u32,
                    back: 1,
                }),
                upload_offset: off,
                width: size[0] as u32,
                height: size[1] as u32,
            });
            return Ok(());
        }

        let mut tex_res: Option<ID3D12Resource> = None;
        self.device.CreateCommittedResource(
            &default_heap(),
            D3D12_HEAP_FLAG_NONE,
            &D3D12_RESOURCE_DESC {
                Dimension: D3D12_RESOURCE_DIMENSION_TEXTURE2D,
                Width: size[0] as u64,
                Height: size[1] as u32,
                DepthOrArraySize: 1,
                MipLevels: 1,
                Format: DXGI_FORMAT_R8G8B8A8_UNORM,
                SampleDesc: DXGI_SAMPLE_DESC { Count: 1, Quality: 0 },
                ..Default::default()
            },
            D3D12_RESOURCE_STATE_COPY_DEST,
            None,
            &mut tex_res,
        )?;
        let tex_res = tex_res.ok_or_else(|| fail("no texture"))?;
        let slot = self.alloc_srv_slot(&tex_res)?;
        let off = self.stage_bytes(size[0], bytes)?;
        self.staged.push(StagedCopy {
            resource: tex_res.clone(),
            sub_box: None,
            upload_offset: off,
            width: size[0] as u32,
            height: size[1] as u32,
        });
        self.textures
            .insert(id, Texture { resource: tex_res, slot });
        Ok(())
    }

    unsafe fn alloc_srv_slot(&mut self, resource: &ID3D12Resource) -> Result<u32> {
        let slot = if let Some(slot) = self.free_srv.pop() {
            slot
        } else {
            if self.next_srv_slot >= SRV_HEAP_CAP {
                return Err(fail("SRV descriptor heap exhausted"));
            }
            let slot = self.next_srv_slot;
            self.next_srv_slot += 1;
            slot
        };
        let handle = D3D12_CPU_DESCRIPTOR_HANDLE {
            ptr: self.srv_start_cpu.ptr + (slot as usize) * (self.srv_handle_size as usize),
        };
        self.device.CreateShaderResourceView(resource, None, handle);
        Ok(slot)
    }

    /// Copy `bytes` into the texture staging upload buffer; returns the offset.
    /// The staging area is frame-scoped: `stage_offset` is reset when the
    /// frame's list is retired, and the GPU has fenced-waited by then.
    unsafe fn stage_bytes(&mut self, width: usize, bytes: &[u8]) -> Result<u64> {
        let off = self.stage_offset;
        let row_bytes = width * 4;
        let row_pitch = row_bytes.next_multiple_of(256);
        let rows = bytes.len() / row_bytes;
        let needed = off as usize + row_pitch * rows;
        let slot = &mut self.tex_upload;
        if slot.as_ref().map_or(true, |(_, _, cap)| *cap < needed) {
            let cap = needed.next_power_of_two().max(1024 * 1024);
            let mut res: Option<ID3D12Resource> = None;
            self.device.CreateCommittedResource(
                &upload_heap(),
                D3D12_HEAP_FLAG_NONE,
                &buffer_desc(cap as u64),
                D3D12_RESOURCE_STATE_GENERIC_READ,
                None,
                &mut res,
            )?;
            let res = res.ok_or_else(|| fail("no texture upload buffer"))?;
            let mut ptr = std::ptr::null_mut();
            res.Map(0, None, Some(&mut ptr))?;
            *slot = Some((res, ptr as *mut u8, cap));
        }
        let (_, ptr, _) = slot.as_ref().unwrap();
        for row in 0..rows {
            let src = &bytes[row * row_bytes..(row + 1) * row_bytes];
            std::ptr::copy_nonoverlapping(
                src.as_ptr(),
                ptr.add(off as usize + row * row_pitch),
                row_bytes,
            );
        }
        self.stage_offset = needed as u64;
        Ok(off)
    }
}

static WARNED_NO_QUEUE: AtomicBool = AtomicBool::new(false);

#[allow(non_snake_case)]
unsafe fn upload_heap() -> D3D12_HEAP_PROPERTIES {
    D3D12_HEAP_PROPERTIES {
        Type: D3D12_HEAP_TYPE_UPLOAD,
        ..Default::default()
    }
}

#[allow(non_snake_case)]
unsafe fn default_heap() -> D3D12_HEAP_PROPERTIES {
    D3D12_HEAP_PROPERTIES {
        Type: D3D12_HEAP_TYPE_DEFAULT,
        ..Default::default()
    }
}

#[allow(non_snake_case)]
fn buffer_desc(width: u64) -> D3D12_RESOURCE_DESC {
    D3D12_RESOURCE_DESC {
        Dimension: D3D12_RESOURCE_DIMENSION_BUFFER,
        Width: width,
        Height: 1,
        DepthOrArraySize: 1,
        MipLevels: 1,
        SampleDesc: DXGI_SAMPLE_DESC { Count: 1, Quality: 0 },
        Layout: D3D12_TEXTURE_LAYOUT_ROW_MAJOR,
        ..Default::default()
    }
}

/// View a slice of plain-old-data as bytes (Vertex, u32 and Color32 are all
/// `#[repr(C)]` with no padding).
fn bytes_of<T>(v: &[T]) -> &[u8] {
    unsafe { std::slice::from_raw_parts(v.as_ptr() as *const u8, std::mem::size_of_val(v)) }
}

impl Drop for Painter {
    fn drop(&mut self) {
        unsafe {
            let _ = CloseHandle(self.fence_event);
        }
    }
}
