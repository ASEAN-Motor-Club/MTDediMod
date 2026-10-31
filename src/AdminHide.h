#pragma once

namespace AdminHide
{
    // Installs a native hook that forces AMotorTownPlayerState::bIsAdmin to
    // false at the point the game sets it. Because the game's own setter also
    // marks the property dirty, clients receive `false` instead of the real
    // value, so the " (Admin)" suffix and the admin star are never rendered.
    //
    // Gated behind MOD_HIDE_ADMIN_FLAG=1 so it can be enabled/disabled per host.
    // Returns true when the hook is installed. No-op if already installed.
    bool Install();
}
