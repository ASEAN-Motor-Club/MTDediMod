#pragma once

namespace TrafficNormalizer
{
    // Normalizes Motor Town AI traffic across dense towns and sparse rural roads
    // via two native inline hooks:
    //   1. Nav_GetRandomRoadNode: spatial-grid stratified sampling (250 m cells)
    //      within an online player's neighborhood (default 1 km) so every road
    //      cell gets equal weight regardless of lane count / road density.
    //   2. Traffic_CanMaterialize: universal LocalCap (default 8 vehicles within
    //      400 m) so multi-lane junctions never spike active AI vehicles.
    //
    // Environment variables (read once at Install):
    //   MOD_TRAFFIC_NORM_ENABLE      = 1 (default) | 0 (disable)
    //   MOD_TRAFFIC_CELL_CM          = 25000 (default, 250 m; 0 disables Hook 1)
    //   MOD_TRAFFIC_ACTIVE_RADIUS_CM = 100000 (default, 1 km; 0 = map-wide)
    //   MOD_TRAFFIC_LOCAL_CAP        = 8 (default; 0 disables cap)
    //   MOD_TRAFFIC_CAP_RADIUS_CM    = 40000 (default, 400 m)
    //
    // Idempotent. Safe to call Uninstall() on mod reload / shutdown.
    bool Install();
    void Uninstall();
}
