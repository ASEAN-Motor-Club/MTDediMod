-- Motor Town 0.7.20 - FText::FText(FString&&)
-- Derived from the 0.7.20 client build (MotorTown-Win64-Shipping.exe,
-- 174,215,168 bytes, 2026-11-18). The 0.7.19 pattern
--   (40 56 57 48 83 EC 48 48 63 72 08) matches 0 times in this build.
-- The generic pattern matches two sibling constructors whose first 289
-- bytes are identical, so the call displacement at +0x28 is pinned to make
-- this pattern resolve to exactly one address. Re-derive on any game update.
function Register()
    return "40 53 57 48 83 EC 38 48 89 6C 24 58 48 8B FA 48 89 74 24 60 48 8B D9 33 F6 4C 89 74 24 30 83 7A 08 01 89 74 24 50 7F 2E E8 E3 0E 00 00 48 8B F0"
end

function OnMatchFound(matchAddress)
    return matchAddress
end
