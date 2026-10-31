#pragma once

namespace AdminHide
{
    // Forces AMotorTownPlayerState::bIsAdmin to serialize as `false` without
    // touching the object's real value. Clients therefore never render the
    // " (Admin)" suffix or the admin star, while the server keeps the true flag
    // and with it every admin permission check.
    //
    // Gated behind MOD_HIDE_ADMIN_FLAG=1 so it can be enabled/disabled per host.
    // Returns true when the hook is installed. No-op if already installed.
    bool Install();
}
