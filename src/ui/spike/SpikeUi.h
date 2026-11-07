#pragma once

// S1a spike: in-process ImGui overlay over Motor Town (DX12 + DX11).
// Client builds only — guarded by the SPIKE_UI compile definition.
namespace SpikeUi
{
    // Installs the swap-chain hooks on a worker thread and returns immediately.
    // Safe to call once from on_unreal_init().
    void Start();

    // Removes hooks / releases device objects. Not called in normal operation
    // (the game exits with the process).
    void Stop();
}
