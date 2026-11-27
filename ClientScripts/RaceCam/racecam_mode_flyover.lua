-- flyover mode: verified numbers from tween_driver7.lua
-- Resolve the RaceCam data directory without hardcoding a drive letter:
-- the RACECAM_DIR environment variable wins; otherwise candidate relative
-- paths are probed by attempting to create a marker file (io.open append).
local function racecam_dir() return require("RaceCam/path").data_dir() end

local M = { name = "route_flyover", log_every = 5 }
local G = {}
_G.RACECAM_TWEEN = G

local WP={
  {-189040.799655,-1284.437107,-13850.000000},
  {-195787.765715,11780.185647,-14031.850630},
  {-179001.556933,14444.533694,-13357.094562},
  {-172448.011485,13831.312150,-12757.524197},
  {-166144.918594,6638.661224,-12103.005047},
  {-161231.675299,-11670.485357,-12013.906924},
  {-146185.216384,-17852.367390,-11630.972934},
  {-135979.495164,-9503.467033,-11441.362703},
  {-155486.098313,9836.012236,-12145.546717},
  {-150138.705506,-2312.375289,-13227.404583},
  {-161893.874856,-3175.368682,-13700.000000},
  {-189053.664153,-1279.771027,-13850.000000},
}
local LUT={
  {0.000,552.392,1276.323,2146.433,3136.195,4218.725,5367.083,6554.447,7754.264,8940.440,10087.617,11171.649,12170.468,13065.773,13846.587,14516.977,15111.142},
  {0.000,622.859,1358.907,2222.877,3209.932,4306.011,5492.492,6748.326,8051.080,9377.484,10703.742,12005.722,13259.071,14439.317,15521.943,16482.497,17296.777},
  {0.000,695.157,1318.848,1878.143,2380.087,2831.753,3240.329,3613.232,3958.249,4283.677,4598.375,4911.695,5233.254,5572.628,5939.096,6341.504,6788.261},
  {0.000,475.479,959.360,1452.888,1957.515,2474.934,3007.113,3556.311,4125.080,4716.256,5332.940,5978.471,6656.387,7370.392,8124.319,8922.091,9767.697},
  {0.000,921.317,1940.415,3047.894,4231.418,5476.982,6769.659,8094.058,9434.659,10776.095,12103.427,13402.476,14660.252,15865.576,17009.986,18089.115,19104.702},
  {0.000,1003.515,2039.802,3106.720,4200.214,5314.801,6443.936,7580.288,8715.957,9842.642,10951.781,12034.678,13082.628,14087.060,15039.713,15932.894,16759.858},
  {0.000,831.781,1733.540,2690.397,3687.138,4708.587,5739.920,6766.991,7776.732,8757.715,9700.973,10601.218,11458.608,12281.086,13086.839,13905.492,14776.206},
  {0.000,1063.893,2423.947,4047.678,5892.937,7913.684,10062.038,12289.150,14545.615,16781.691,18947.431,20992.769,22867.585,24521.787,25905.448,26969.162,27665.464},
  {0.000,333.424,537.713,959.834,1623.893,2496.880,3538.581,4706.998,5959.579,7253.665,8546.758,9796.800,10962.610,12004.762,12887.673,13585.564,14103.037},
  {0.000,440.879,872.199,1319.648,1803.310,2336.668,2927.733,3580.692,4297.262,5077.623,5921.022,6826.167,7791.489,8815.316,9896.004,11032.030,12222.064},
  {0.000,1325.075,2846.308,4532.563,6352.610,8275.174,10268.948,12302.607,14344.815,16364.230,18329.501,20209.277,21972.201,23586.918,25022.072,26246.310,27228.290},
  {0.000,733.681,1253.683,1591.527,1787.534,1916.361,2078.996,2303.022,2575.864,2876.330,3181.594,3469.833,3723.430,3937.080,4137.800,4394.444,4774.489},
}
local SEG={
  15111,
  32408,
  39196,
  48964,
  68069,
  84828,
  99605,
  127270,
  141373,
  153595,
  180823,
  185598,
}
local N=#WP
local TOTAL=185598
local function at(i) return WP[((i-1)%N)+1] end
local function spline(i,t)
  local p0,p1,p2,p3=at(i-1),at(i),at(i+1),at(i+2)
  local t2=t*t; local t3=t2*t
  local function c(k)
    local a,b,cc,dd=p0[k],p1[k],p2[k],p3[k]
    return 0.5*((2*b)+(-a+cc)*t+(2*a-5*b+4*cc-dd)*t2+(-a+3*b-3*cc+dd)*t3)
  end
  return {c(1),c(2),c(3)}
end
local function sample(i,s)
  local lut=LUT[i]; local lo,hi=0,16
  while hi-lo>1 do local m=math.floor((lo+hi)/2); if lut[m+1]<=s then lo=m else hi=m end end
  local a,b=lut[lo+1],lut[hi+1]
  local t=(lo+(b>a and (s-a)/(b-a) or 0))/16.0
  return spline(i,math.min(t,1.0))
end
local function pos_at(d)
  d=d%TOTAL
  local i=N
  for k=1,N do if d<SEG[k] then i=k break end end
  local prev = (i>1) and SEG[i-1] or 0
  return sample(i,d-prev)
end

local function aim(pos, look)
  local dx = look[1] - pos[1]; local dy = look[2] - pos[2]; local dz = look[3] - pos[3]
  return {
    Pitch = math.deg(math.atan(dz, math.sqrt(dx * dx + dy * dy))),
    Yaw = math.deg(math.atan(dy, dx)), Roll = 0.0,
  }
end

M.init = function(Core)
  G.d = 0.0
  G.core = Core
  Core.pos_at = pos_at
end

M.apply = function(Core)
  G.d = G.d + 50.0
  if G.d >= TOTAL then G.d = G.d - TOTAL end
  local p = pos_at(G.d); p[3] = p[3] + 350.0; G.cp = p
  local lk = pos_at(G.d + 2500.0)
  Core.apply_pose(p, aim(p, lk), 76.0)
end

M.log = function(Core)
  if _G.RACECAM_LOG ~= 1 then return end
  local cam = Core.cam
  local ok, pl = pcall(function() return cam:K2_GetActorLocation() end)
  local okr, rot = pcall(function() return cam:K2_GetActorRotation() end)
  if ok and okr and pl and rot then
    local f = io.open(racecam_dir() .. "tween_core.txt", "a")
    if f then
      f:write(string.format("POS %d %.1f %.1f %.1f CP %.1f %.1f %.1f ROT %.2f %.2f %.2f\n",
        Core.n, pl.X, pl.Y, pl.Z, G.cp[1], G.cp[2], G.cp[3], rot.Pitch, rot.Yaw, rot.Roll))
      f:close()
    end
  end
end

return Core.start(M)
