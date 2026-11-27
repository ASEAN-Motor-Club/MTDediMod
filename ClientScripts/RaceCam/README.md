# AMC RaceCam (client)

Local broadcast camera system. The panel is served by LuaSocket at
`http://127.0.0.1:8767/` from inside the game process; nothing goes through
the remote server.

- Boots in **standby** with the admin client variant. It does not move the
  camera until you press **A** in the panel.
- **A** arms/restarts the shot engine, **S** starts the cue clock,
  **1-9** select shots, **X** panic-stops and restores the pawn view.
- Token is auto-created at `Scripts/RaceCam/data/racecam_token.txt` on first
  launch. Paste it into the panel; never share it in chat.
- OBS WebSocket control is in the panel; the password is entered in the panel
  from your local `obs_ws_password.txt`, never in chat.
- The HTTP panel lives in-process and dies with the game. It comes back on the
  next game launch because the boot module is loaded by `ClientScripts/main.lua`.

Plan/route files live in `data/`; `active_plan.txt` selects `plan_<id>.lua` and
`route_<id>.lua`. The bundled `aewol` plan contains 17 shots with universal
1-9 director slots.
