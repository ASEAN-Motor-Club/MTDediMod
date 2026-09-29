# Spike Pad Rework — Feature Report (staging-verified)

Date: 2026-09-29 · Branch: `feat/spikepad-probe` (PR #37) · Head deployed on staging hot, verified live
Status: **feature functional and live-verified on staging**; ready for review → pin → release pipeline

## What this does

Replaces vanilla's instant tire-pop spike pad behavior with an episodic damage
system, server-side only (no client changes):

- **Kill the vanilla trigger** (disarm): on every pad discovery, the pad's
  TriggerBox gets `SetGenerateOverlapEvents(false)`. The native
  "suspect entered → instant flat" chain never fires. The physical bump
  (OverlapBox) and the spike visuals are untouched — everyone still feels the
  bump; the pop is ours.
- **Episode damage instead**: our own game-thread contact engine (250ms) tests
  every player vehicle's wheels against every live pad. Wheel inside pad →
  episode opens → if the driver is a vanilla suspect (`AMTPolice.Net_Suspects`),
  write tire damage via `ServerSetPartDamage` (native replication, vanilla
  clients see it); innocents/police get bump only, zero writes.
- **Damage curve**: fresh tire 0.0 → first episode 0.50 → second episode 1.00.
  Partially worn tires step +0.50 toward 1.00. Per-wheel (slots 19–22,
  `Tire0..Tire3`), so a grazing pass pops only the wheels that touched the strip.

## What was verified live on staging (2026-09-29)

- **Vanilla kill works (M1 disarm)**: zero native pops on disarmed pads across
  all suspect passes. The only pops observed were in a deliberate config-reset
  window where M1 was off — confirms M1's kill is total.
- **Innocent safety**: police vehicle passes (Elisa2) over live pads opened
  episodes classified innocent, no damage written. Non-suspect players same.
- **Gate works**: pogie flagged suspect via the suspect endpoint; 3 seconds
  later his pass over the pad was gated as suspect.
- **Damage curve works**: his four wheels went 0.00→0.50 (front) and
  0.50→1.00 (rear) on one pass with prior state. Writes logged
  `applied=true`, read back via a second endpoint: tires at 0.502/1.0/0.501/1.0.
- **Per-wheel episodes**: episodes open/close on wheel enter/exit of each pad,
  keyed per (vehicle, wheel, pad). Rumble re-entry within one contact absorbed;
  leaving and returning opens a fresh episode.
- **Real summon flow**: a player police officer's barrier summon was
  intercepted and disarmed exactly like debug-spawned pads.
- **No leaks**: 46+ sweeps, Lua state bounded, game RSS shrinking over sample
  windows, zero crash dumps, no unhandled Lua errors post-fix.

## Open items

- **Puncture-at-100 confirmation** (P3 core): pogie's rear tires hit 1.0 —
  need one pass/observation to confirm the native engine punctures at exactly
  1.0 (assumed; wear UI implies it).
- **Suspect list timing** (P5 note): `Net_Suspects` membership appears only
  when police AI engages / state refreshes — a wanted player with stars read
  0 in the list during one window. We gate at episode-open on the live list;
  behavior is consistent with vanilla's own gate timing.
- **Disarm config default**: test build defaults `disarmMethod=none` (vanilla)
  and resets on reload — the feature build must default to `overlap` at load.
- **Diagnostic endpoints** ship as-is for ops visibility
  (`GET /debug/spikepad`, `/vehicle`, `POST /spawn|/despawn|/disarmnow|
  /config|/hooktest`), harmless to keep in release.

## Architecture notes (for the reviewer)

- Server-side Lua only (`Scripts/SpikePadManager.lua`), loaded by UE4SS on the
  dedicated server; prod untouched until pinned (per standard release flow).
- Detection is our own proximity test — the BP `ReceiveActorBeginOverlap` hook
  demonstrably never fires for vehicles (verified: 8 events, all world
  geometry). Pad's road-strip box + tolerance, yaw-independent axis-aligned 2D
  test in the pad's own frame.
- `NotifyOnNewObject` does not fire on this build (known mod caveat); pads are
  discovered by continuous class scan (`FindAllOf("MTSpikePad")`), deduped by
  full instance name + location, pruned by validity each sweep. Re-discovery
  doubles as re-disarm — covers pooled pad reuse re-enabling overlaps.
- Boot-order self-heal: the BP hook registration fails at boot (BP class not
  yet loaded); the sweep retries until it sticks (~10s after map load).
- Damage writes go through `ServerSetPartDamage` → native
  `MulticastSetPartDamage` replication — vanilla clients (modded or not) see
  the tire state; coexists with normal wear accumulation without stomping.
- Thread safety: all UObject access on the game thread
  (`LoopInGameThreadWithDelay`), no `LoopAsync`/`ExecuteWithDelay` anywhere.
- TArray iteration on this UE4SS build: `#arr` + `arr[i]` works for
  `Net_Parts`; component locations must come from
  `K2_GetComponentLocation` (wheels are components, not actors) and struct
  math must be `tonumber()`-guarded — the silent pcall-abort of these two was
  the bug that made the feature look "deployed but dead" for a session.
- Disarm ladder rationale: M1 chosen and held because it verified sufficient;
  M2–M6 are contingency rungs (collision-off → zero extent → destroy
  component → registry removal), strictly riskier, with M6 actually hostile to
  our own tracking (vanilla cleanup + our sweep use that registry).

## Commits on the branch (feature-relevant tail)

- `1dd0092` name resolution + substring filter for debug endpoints
- `0222731` sweep hook self-heal (boot-order)
- `2b83ff5` episode engine (contact detection, gate, damage curve)
- `0379101` TArray iteration fix, pad dedupe, despawn endpoint, retroactive disarm
- (unpushed worktree head) wheel-location fix (`K2_GetComponentLocation`),
  tonumber guards, wheels diagnostic — the fix that made episodes actually
  fire; to be committed as cleanup before review.
