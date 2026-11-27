//! Minimal egui renderer for D3D11.
//!
//! Draws into the game's back buffer just before Present. All our pipeline
//! state lives in a private `ID3DDeviceContextState`: we swap it in, draw,
//! and swap the game's state back, so nothing we bind can leak into UE's
//! next frame (and we need no per-field save/restore).

use std::collections::HashMap;
use std::ffi::c_void;

use egui::epaint::{ClippedPrimitive, ImageData, Primitive, Vertex};
use egui::{TextureId, TexturesDelta};
use windows::core::{s, Error, Interface, Result, PCSTR};
use windows::Win32::Foundation::{E_FAIL, RECT};
use windows::Win32::Graphics::Direct3D::Fxc::D3DCompile;
use windows::Win32::Graphics::Direct3D::*;
use windows::Win32::Graphics::Direct3D11::*;
use windows::Win32::Graphics::Dxgi::Common::*;
use windows::Win32::Graphics::Dxgi::IDXGISwapChain;

const SHADER: &str = include_str!("shader.hlsl");

struct Texture {
    tex: ID3D11Texture2D,
    srv: ID3D11ShaderResourceView,
}

pub struct Painter {
    device: ID3D11Device,
    context: ID3D11DeviceContext1,
    state: ID3DDeviceContextState,
    vs: ID3D11VertexShader,
    ps: ID3D11PixelShader,
    layout: ID3D11InputLayout,
    cbuffer: ID3D11Buffer,
    blend: ID3D11BlendState,
    raster: ID3D11RasterizerState,
    depth: ID3D11DepthStencilState,
    sampler: ID3D11SamplerState,
    vbuf: Option<(ID3D11Buffer, usize)>,
    ibuf: Option<(ID3D11Buffer, usize)>,
    textures: HashMap<TextureId, Texture>,
    target: Option<(ID3D11RenderTargetView, u32, u32)>,
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

impl Painter {
    pub unsafe fn new(device: &ID3D11Device) -> Result<Self> {
        let device1: ID3D11Device1 = device.cast()?;
        let context: ID3D11DeviceContext1 = device.GetImmediateContext()?.cast()?;

        let mut state = None;
        device1.CreateDeviceContextState(
            0,
            &[device.GetFeatureLevel()],
            D3D11_SDK_VERSION,
            &ID3D11Device1::IID,
            None,
            Some(&mut state),
        )?;

        let vs_blob = compile(s!("vs_main"), s!("vs_4_0"))?;
        let ps_blob = compile(s!("ps_main"), s!("ps_4_0"))?;
        let mut vs = None;
        device.CreateVertexShader(blob_bytes(&vs_blob), None, Some(&mut vs))?;
        let mut ps = None;
        device.CreatePixelShader(blob_bytes(&ps_blob), None, Some(&mut ps))?;

        // Matches egui::epaint::Vertex: pos [f32;2], uv [f32;2], color [u8;4].
        let elements = [
            D3D11_INPUT_ELEMENT_DESC {
                SemanticName: s!("POSITION"),
                SemanticIndex: 0,
                Format: DXGI_FORMAT_R32G32_FLOAT,
                InputSlot: 0,
                AlignedByteOffset: 0,
                InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA,
                InstanceDataStepRate: 0,
            },
            D3D11_INPUT_ELEMENT_DESC {
                SemanticName: s!("TEXCOORD"),
                SemanticIndex: 0,
                Format: DXGI_FORMAT_R32G32_FLOAT,
                InputSlot: 0,
                AlignedByteOffset: 8,
                InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA,
                InstanceDataStepRate: 0,
            },
            D3D11_INPUT_ELEMENT_DESC {
                SemanticName: s!("COLOR"),
                SemanticIndex: 0,
                Format: DXGI_FORMAT_R8G8B8A8_UNORM,
                InputSlot: 0,
                AlignedByteOffset: 16,
                InputSlotClass: D3D11_INPUT_PER_VERTEX_DATA,
                InstanceDataStepRate: 0,
            },
        ];
        let mut layout = None;
        device.CreateInputLayout(&elements, blob_bytes(&vs_blob), Some(&mut layout))?;

        let mut cbuffer = None;
        device.CreateBuffer(
            &D3D11_BUFFER_DESC {
                ByteWidth: 16,
                Usage: D3D11_USAGE_DYNAMIC,
                BindFlags: D3D11_BIND_CONSTANT_BUFFER.0 as u32,
                CPUAccessFlags: D3D11_CPU_ACCESS_WRITE.0 as u32,
                ..Default::default()
            },
            None,
            Some(&mut cbuffer),
        )?;

        // egui emits premultiplied alpha.
        let mut blend_desc = D3D11_BLEND_DESC::default();
        blend_desc.RenderTarget[0] = D3D11_RENDER_TARGET_BLEND_DESC {
            BlendEnable: true.into(),
            SrcBlend: D3D11_BLEND_ONE,
            DestBlend: D3D11_BLEND_INV_SRC_ALPHA,
            BlendOp: D3D11_BLEND_OP_ADD,
            SrcBlendAlpha: D3D11_BLEND_INV_DEST_ALPHA,
            DestBlendAlpha: D3D11_BLEND_ONE,
            BlendOpAlpha: D3D11_BLEND_OP_ADD,
            RenderTargetWriteMask: D3D11_COLOR_WRITE_ENABLE_ALL.0 as u8,
        };
        let mut blend = None;
        device.CreateBlendState(&blend_desc, Some(&mut blend))?;

        let mut raster = None;
        device.CreateRasterizerState(
            &D3D11_RASTERIZER_DESC {
                FillMode: D3D11_FILL_SOLID,
                CullMode: D3D11_CULL_NONE,
                ScissorEnable: true.into(),
                DepthClipEnable: true.into(),
                ..Default::default()
            },
            Some(&mut raster),
        )?;

        let mut depth = None;
        device.CreateDepthStencilState(
            &D3D11_DEPTH_STENCIL_DESC {
                DepthEnable: false.into(),
                StencilEnable: false.into(),
                ..Default::default()
            },
            Some(&mut depth),
        )?;

        let mut sampler = None;
        device.CreateSamplerState(
            &D3D11_SAMPLER_DESC {
                Filter: D3D11_FILTER_MIN_MAG_MIP_LINEAR,
                AddressU: D3D11_TEXTURE_ADDRESS_CLAMP,
                AddressV: D3D11_TEXTURE_ADDRESS_CLAMP,
                AddressW: D3D11_TEXTURE_ADDRESS_CLAMP,
                ComparisonFunc: D3D11_COMPARISON_ALWAYS,
                MaxLOD: f32::MAX,
                ..Default::default()
            },
            Some(&mut sampler),
        )?;

        let missing = || fail("D3D11 object creation returned null");
        Ok(Self {
            device: device.clone(),
            context,
            state: state.ok_or_else(missing)?,
            vs: vs.ok_or_else(missing)?,
            ps: ps.ok_or_else(missing)?,
            layout: layout.ok_or_else(missing)?,
            cbuffer: cbuffer.ok_or_else(missing)?,
            blend: blend.ok_or_else(missing)?,
            raster: raster.ok_or_else(missing)?,
            depth: depth.ok_or_else(missing)?,
            sampler: sampler.ok_or_else(missing)?,
            vbuf: None,
            ibuf: None,
            textures: HashMap::new(),
            target: None,
        })
    }

    /// Drop our view of the back buffer (must happen before ResizeBuffers).
    pub fn release_target(&mut self) {
        self.target = None;
    }

    /// Borrow the underlying D3D11 device (used by the D3D11On12 path to
    /// create RTVs for wrapped DX12 back buffers).
    pub fn device(&self) -> &ID3D11Device {
        &self.device
    }

    /// Borrow the immediate D3D11 context (used by D3D11On12 to Flush after
    /// ReleaseWrappedResources and before ResizeBuffers).
    pub fn context(&self) -> &ID3D11DeviceContext1 {
        &self.context
    }

    /// Bind an externally created render target view (D3D11On12 per-frame
    /// wrapped back buffer).
    pub fn set_target(&mut self, rtv: ID3D11RenderTargetView, width: u32, height: u32) {
        self.target = Some((rtv, width, height));
    }

    /// Make sure we hold an RTV for the current back buffer; returns its size.
    pub unsafe fn ensure_target(&mut self, swapchain: &IDXGISwapChain) -> Result<(u32, u32)> {
        if let Some((_, w, h)) = &self.target {
            return Ok((*w, *h));
        }
        let back: ID3D11Texture2D = swapchain.GetBuffer(0)?;
        let mut desc = D3D11_TEXTURE2D_DESC::default();
        back.GetDesc(&mut desc);
        let mut rtv = None;
        self.device.CreateRenderTargetView(&back, None, Some(&mut rtv))?;
        let rtv = rtv.ok_or_else(|| fail("no RTV"))?;
        self.target = Some((rtv, desc.Width, desc.Height));
        Ok((desc.Width, desc.Height))
    }

    pub unsafe fn paint(
        &mut self,
        primitives: &[ClippedPrimitive],
        delta: &TexturesDelta,
        pixels_per_point: f32,
    ) -> Result<()> {
        for (id, image) in &delta.set {
            self.update_texture(*id, image)?;
        }

        let result = self.draw(primitives, pixels_per_point);

        // Free after drawing: this frame's meshes may still reference them.
        for id in &delta.free {
            self.textures.remove(id);
        }
        result
    }

    unsafe fn draw(&mut self, primitives: &[ClippedPrimitive], ppp: f32) -> Result<()> {
        let Some((rtv, width, height)) = self.target.clone() else {
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
            return Ok(());
        }

        let vbuf = self.upload(true, bytes_of(&vertices))?;
        let ibuf = self.upload(false, bytes_of(&indices))?;

        // Screen size in points for the vertex shader.
        let mut mapped = D3D11_MAPPED_SUBRESOURCE::default();
        self.context
            .Map(&self.cbuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, Some(&mut mapped))?;
        let cb = [width as f32 / ppp, height as f32 / ppp, 0.0, 0.0];
        std::ptr::copy_nonoverlapping(cb.as_ptr(), mapped.pData as *mut f32, 4);
        self.context.Unmap(&self.cbuffer, 0);

        let mut previous = None;
        self.context.SwapDeviceContextState(&self.state, Some(&mut previous));

        let ctx = &self.context;
        ctx.OMSetRenderTargets(Some(&[Some(rtv)]), None);
        ctx.OMSetBlendState(&self.blend, Some(&[0.0; 4]), 0xffff_ffff);
        ctx.OMSetDepthStencilState(&self.depth, 0);
        ctx.RSSetState(&self.raster);
        ctx.RSSetViewports(Some(&[D3D11_VIEWPORT {
            TopLeftX: 0.0,
            TopLeftY: 0.0,
            Width: width as f32,
            Height: height as f32,
            MinDepth: 0.0,
            MaxDepth: 1.0,
        }]));
        ctx.IASetInputLayout(&self.layout);
        ctx.IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
        let stride = std::mem::size_of::<Vertex>() as u32;
        let offset = 0u32;
        ctx.IASetVertexBuffers(0, 1, Some(&Some(vbuf)), Some(&stride), Some(&offset));
        ctx.IASetIndexBuffer(&ibuf, DXGI_FORMAT_R32_UINT, 0);
        ctx.VSSetShader(&self.vs, None);
        ctx.VSSetConstantBuffers(0, Some(&[Some(self.cbuffer.clone())]));
        ctx.PSSetShader(&self.ps, None);
        ctx.PSSetSamplers(0, Some(&[Some(self.sampler.clone())]));

        for (tex_id, clip, first, count, base) in draws {
            let Some(tex) = self.textures.get(&tex_id) else {
                continue;
            };
            let left = (clip.min.x * ppp).round().clamp(0.0, width as f32) as i32;
            let top = (clip.min.y * ppp).round().clamp(0.0, height as f32) as i32;
            let right = (clip.max.x * ppp).round().clamp(0.0, width as f32) as i32;
            let bottom = (clip.max.y * ppp).round().clamp(0.0, height as f32) as i32;
            if right <= left || bottom <= top {
                continue;
            }
            ctx.RSSetScissorRects(Some(&[RECT { left, top, right, bottom }]));
            ctx.PSSetShaderResources(0, Some(&[Some(tex.srv.clone())]));
            ctx.DrawIndexed(count, first, base);
        }

        // Hand the game back exactly the state it had.
        if let Some(prev) = previous {
            self.context.SwapDeviceContextState(&prev, None);
        }
        Ok(())
    }

    /// Write `data` into the dynamic vertex or index buffer, growing it if needed.
    unsafe fn upload(&mut self, vertex: bool, data: &[u8]) -> Result<ID3D11Buffer> {
        let slot = if vertex { &mut self.vbuf } else { &mut self.ibuf };
        if slot.as_ref().map_or(true, |(_, cap)| *cap < data.len()) {
            let cap = data.len().next_power_of_two().max(64 * 1024);
            let bind = if vertex { D3D11_BIND_VERTEX_BUFFER } else { D3D11_BIND_INDEX_BUFFER };
            let mut buf = None;
            self.device.CreateBuffer(
                &D3D11_BUFFER_DESC {
                    ByteWidth: cap as u32,
                    Usage: D3D11_USAGE_DYNAMIC,
                    BindFlags: bind.0 as u32,
                    CPUAccessFlags: D3D11_CPU_ACCESS_WRITE.0 as u32,
                    ..Default::default()
                },
                None,
                Some(&mut buf),
            )?;
            *slot = Some((buf.ok_or_else(|| fail("no buffer"))?, cap));
        }
        let buf = slot.as_ref().unwrap().0.clone();
        let mut mapped = D3D11_MAPPED_SUBRESOURCE::default();
        self.context
            .Map(&buf, 0, D3D11_MAP_WRITE_DISCARD, 0, Some(&mut mapped))?;
        std::ptr::copy_nonoverlapping(data.as_ptr(), mapped.pData as *mut u8, data.len());
        self.context.Unmap(&buf, 0);
        Ok(buf)
    }

    unsafe fn update_texture(&mut self, id: TextureId, delta: &egui::epaint::ImageDelta) -> Result<()> {
        let (size, pixels): ([usize; 2], Vec<egui::Color32>) = match &delta.image {
            ImageData::Color(img) => (img.size, img.pixels.clone()),
            ImageData::Font(img) => (img.size, img.srgba_pixels(None).collect()),
        };
        let bytes = bytes_of(&pixels);
        let row_pitch = (size[0] * 4) as u32;

        if let Some(pos) = delta.pos {
            // Partial update (the font atlas grows this way).
            let Some(tex) = self.textures.get(&id) else {
                return Ok(());
            };
            let dst = D3D11_BOX {
                left: pos[0] as u32,
                top: pos[1] as u32,
                front: 0,
                right: (pos[0] + size[0]) as u32,
                bottom: (pos[1] + size[1]) as u32,
                back: 1,
            };
            self.context.UpdateSubresource(
                &tex.tex,
                0,
                Some(&dst),
                bytes.as_ptr() as *const c_void,
                row_pitch,
                0,
            );
            return Ok(());
        }

        let desc = D3D11_TEXTURE2D_DESC {
            Width: size[0] as u32,
            Height: size[1] as u32,
            MipLevels: 1,
            ArraySize: 1,
            Format: DXGI_FORMAT_R8G8B8A8_UNORM,
            SampleDesc: DXGI_SAMPLE_DESC { Count: 1, Quality: 0 },
            Usage: D3D11_USAGE_DEFAULT,
            BindFlags: D3D11_BIND_SHADER_RESOURCE.0 as u32,
            ..Default::default()
        };
        let init = D3D11_SUBRESOURCE_DATA {
            pSysMem: bytes.as_ptr() as *const c_void,
            SysMemPitch: row_pitch,
            SysMemSlicePitch: 0,
        };
        let mut tex = None;
        self.device.CreateTexture2D(&desc, Some(&init), Some(&mut tex))?;
        let tex = tex.ok_or_else(|| fail("no texture"))?;
        let mut srv = None;
        self.device.CreateShaderResourceView(&tex, None, Some(&mut srv))?;
        let srv = srv.ok_or_else(|| fail("no SRV"))?;
        self.textures.insert(id, Texture { tex, srv });
        Ok(())
    }
}

/// View a slice of plain-old-data as bytes (Vertex, u32 and Color32 are all
/// `#[repr(C)]` with no padding).
fn bytes_of<T>(v: &[T]) -> &[u8] {
    unsafe { std::slice::from_raw_parts(v.as_ptr() as *const u8, std::mem::size_of_val(v)) }
}
