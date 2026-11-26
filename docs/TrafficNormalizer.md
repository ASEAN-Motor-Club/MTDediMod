# AI Traffic Normalizer (`TrafficNormalizer`)

Native UE4SS C++ module in `MotorTownMods` (`src/TrafficNormalizer.h`, `src/TrafficNormalizer.cpp`) that normalizes AI traffic density across dense urban road networks and sparse rural highways.

---

## Root Cause (Why Vanilla Traffic Scales With Road Density)

Static analysis (Ghidra decompilation of `MotorTown-Win64-Shipping.exe` 0.7.19 and `MotorTownServer-Win64-Shipping.exe` 0.7.19 / 0.7.20-B1157) established the exact mechanism inside `AMTAIVehicleSpawnSystem`:

1. **Global virtual-agent pool:** `AMTAIVehicleSpawnSystem::Tick` maintains a global `TSparseArray` (`spawnSys + 0x2d8`) of virtual traffic agents sized to `sum(SpawnSettings[i].MaxCount) * NPCVehicleDensity * mh.trafficMultiplier` (~355 agents at vanilla `density = 1.0`).
2. **Uniform node sampling:** Every new virtual agent and roaming re-route calls `AMotorTownNavigation::GetRandomRoadNode(nav, &zero, -1.0f, -1.0f, ...)` with `max_dist = -1` (map-wide). That function picks `rand() % GraphData.Nodes.Num()` uniformly over `AMotorTownNavigation::GraphData.Nodes`.
3. **Node density = road-lane length:** `GraphData.Nodes` has one node per `step_cm` per lane per road spline. A dense urban grid or multi-lane interchange has 5–10× more nav nodes per square kilometer than a two-lane rural road, so it receives 5–10× more virtual agents — and therefore 5–10× more materialized AI vehicles around the player.
4. **Why map-wide stratification alone is insufficient:** Stratifying uniformly over all `803` occupied 250 m road cells on Jeju (~50 km² of road-bearing area) flattens the urban spike down to the map-wide average (`355 / 803 ≈ 0.44 agents/cell`), making traffic scarce everywhere (especially on tighter spawn rings). Inflating the global pool to compensate (e.g., `density = 5.0` → ~1,775 agents) hits `mh.trafficTickPerFrame`, starving each agent's tick rate (once every 8–16 s) so virtual agents drive straight across the spawn annulus between ticks without being checked for materialization.

---

## Solution (2-Hook Native Architecture)

`TrafficNormalizer` installs two cross-version inline detours at `MotorTownMods::on_unreal_init()` and removes them cleanly on `~MotorTownMods()`:

### Hook 1 — `Nav_GetRandomRoadNode` (Player-Neighborhood Spatial-Grid Stratification)
- Builds a 2D spatial grid of `250 m × 250 m` (`MOD_TRAFFIC_CELL_CM`) cells from `AMotorTownNavigation::GraphData.Nodes` once per navigation graph (rebuilt only if `nav` pointer or node count changes; on Jeju: `17,687` total nodes → `7,497` valid AI-eligible nodes → `803` occupied cells).
- Intercepts map-wide calls (`max_dist <= 0`).
- Reads live online player cluster locations from `AMTAIVehicleSpawnSystem + 0x340` (`TArray<FPlayerCluster>`, stride `0x40`, `FVector Location` at `+0x28`), cached by Hook 2.
- Picks a random online player cluster and selects **uniformly at random among occupied 250 m cells within `MOD_TRAFFIC_ACTIVE_RADIUS_CM` (default `1 km`)** of that player — falling back to all occupied cells when 0 players are online or no cells are in range.
- Picks a random node from that cell and delegates back to the original `Nav_GetRandomRoadNode(nav, &picked_pos, 0.0f, 500.0f, out_node, node_flag_mask, road_flag_mask)` so the game performs all flag validation and `FMTRoadGraphNode` struct copying natively.
- **Effect:** Every 250 m road cell around a player gets equal spawn probability regardless of lane count or intersection density, while keeping the vanilla `density = 1.0` pool fast-ticking (~355 agents concentrated into ~15–40 cells around active players instead of diluted across 803 cells).

### Hook 2 — `Traffic_CanMaterialize` (Universal Local Cap)
- Caches `AMTAIVehicleSpawnSystem*` (`spawnSys`) for Hook 1 on every tick.
- Runs the original `Traffic_CanMaterialize(agent, bWarmup, spawnSys)` first (preserving `NPCVehicleDensity = 0`, `mh.trafficStoppedPlayerLocalCap`, distance ring, and line-of-sight checks).
- When the original returns `true`, scans the `TSparseArray` at `spawnSys + 0x2d8` (handling both inline `InlineData[4]` at `+0x2e8` and heap `SecondaryData*` at `+0x2f8` when `NumBits > 128`) and counts already-materialized (`bIsVirtual == 0` at `+0x24`) vehicles within `MOD_TRAFFIC_CAP_RADIUS_CM` (default `400 m`) of the candidate via `GetAgentPosition`.
- Rejects the materialization if `active_nearby >= MOD_TRAFFIC_LOCAL_CAP` (default `8`). Never force-despawns already-materialized vehicles; natural dematerialization at `1.2 × MaxDistance` handles excess.

---

## Cross-Version AOBs & Dynamic Offsets

All three targets are located by unique 1-hit AOB scans in `.text` — verified on `client-0.7.19`, `srv-0.7.19-c1v2`, and `srv-0.7.20(B1157)` — and struct offsets are extracted directly from the matched machine code at startup:

| Symbol / Field | 0.7.19 (`c1v2`) | 0.7.20 (`B1157`) | Resolution |
|---|---|---|---|
| `Nav_GetRandomRoadNode` | `0x4d2a7a0` | `0x5172b10` | AOB anchor + prologue walk |
| `Traffic_CanMaterialize` | `0x4b31a00` | `0x4e96df0` | Entry AOB (1 hit) |
| `GetAgentPosition` | `0x4b2cbb0` | `0x4e91570` | Entry AOB (`EC 50` / `EC 40` wildcarded, 1 hit) |
| `Nav -> GraphData*` | `+0x358` | `+0x3d0` | Extracted from `Nav_GetRandomRoadNode` |
| `FMTRoadGraphNode` stride | `0xa8` | `0xb0` | Extracted from `Nav_GetRandomRoadNode` |
| `AMTRoad::RoadFlags` | `+0x2d0` | `+0x2d4` | Extracted from `Nav_GetRandomRoadNode` |
| `FVirtualTrafficAgent` stride | `0xd0` | `0x130` | Extracted from `Traffic_CanMaterialize` |
| `FPlayerCluster::Location` | `+0x28` | `+0x28` | Fixed (identical on 0.7.19 & 0.7.20) |
| `TSparseArray` (`+0x2d8`) | `SecondaryData +0x2f8`, `NumBits +0x300` | same | UE5 `TBitArray<TInlineAllocator<4>>` |

---

## Configuration (Environment Variables)

Read once at `MotorTownMods::on_unreal_init()`. All have safe defaults:

| Variable | Default | Description |
|---|---|---|
| `MOD_TRAFFIC_NORM_ENABLE` | `1` | Set `0` to disable both hooks completely (instant rollback without rebuilding). |
| `MOD_TRAFFIC_CELL_CM` | `25000` | Spatial grid cell width in cm (`250 m`). Set `0` to disable Hook 1. |
| `MOD_TRAFFIC_ACTIVE_RADIUS_CM` | `100000` | Player-neighborhood radius in cm (`1 km`). Set `0` for map-wide stratification. |
| `MOD_TRAFFIC_LOCAL_CAP` | `8` | Max materialized AI vehicles within `MOD_TRAFFIC_CAP_RADIUS_CM`. Set `0` to disable cap (Hook 2 still caches `spawnSys` for Hook 1). |
| `MOD_TRAFFIC_CAP_RADIUS_CM` | `40000` | Local-cap neighborhood radius in cm (`400 m`). |

---

## Logging & Verification

Writes directly to `MotorTown\Saved\ServerLog\amc_traffic_norm.log` (file-only — never calls UE4SS `Output::send` to avoid cross-thread log races):

- **Startup:** `init: ...`, `Hook 1 OK: ...`, `Hook 2 OK: ...`, `spatial grid built: ...`
- **First player cluster lock:** `local_player_cluster: num=1 pos=(x,y,z)` (verify against Host Web API `GET /player/list`)
- **60 s telemetry:** `stats: grid_cells=803 grid_nodes=17687 strat_hits=... local_hits=... strat_fallbacks=0 cap_allowed=... cap_rejected=... cap_errors=0`

`cap_errors > 0` indicates an SEH-caught invalid memory read (e.g., if a future game update shifts a `TSparseArray` offset) — the hook fails open (`return true`) rather than crashing the server.

---

## Engineering Notes & Pitfalls Avoided

- **`/EHa` + `__declspec(noinline)` + `volatile` on SEH helpers:** `TrafficNormalizer.cpp` is compiled with `/EHa` via `set_source_files_properties` in `src/CMakeLists.txt`. Under `/O2 /EHsc`, `clang-cl` inlines SEH read helpers and strips `__try/__except` frames around raw pointer dereferences.
- **UE5 `TBitArray<TInlineAllocator<4>>` layout:** Inline capacity is 128 bits (`+0x2e8..+0x2f7`); once the virtual-agent pool exceeds 128 slots (~355 at `density = 1.0`), allocation bits move to heap `SecondaryData*` at `+0x2f8` (`NumBits` at `+0x300`) and `+0x2e8` holds stale/all-ones inline bits.
- **Runtime traffic density testing on staging:** When a server boots with `"NPCVehicleDensity": 0.0` in `DedicatedServerConfig.json`, the Mod API (`POST :5001/status/traffic`) alone is blocked by the engine's global `NPCVehicleDensity <= 0` gate; set it via the game's Host Web API (`POST :8081/server/config/npc-vehicle-density/?password=...&value=1.0`) first.
