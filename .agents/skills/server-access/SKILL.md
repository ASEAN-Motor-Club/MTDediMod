---
name: server-access
description: SSH access to AMC servers and debugging amc-backend services
---

# Server Access & Debugging

## SSH Access

Both servers require **Tailscale** for SSH.

```bash
ssh root@asean-mt-server     # Main server (game + backend)
ssh root@amc-peripheral      # Peripheral server (radio, bots)
```

## amc-backend Services

The `amc-backend` runs directly on `asean-mt-server` as host-level systemd services.

### Check service status

```bash
systemctl status amc-worker
systemctl status amc-backend
systemctl status postgresql
```

### View logs

```bash
journalctl -u amc-worker -n 100 --no-pager
journalctl -u amc-worker --since '1 hour ago' --no-pager
```

### Restart a service

```bash
systemctl restart amc-worker
systemctl restart amc-backend
```

### Django management commands

Use the `amcm` wrapper (available to root):
```bash
amcm <command>
```

For example:
```bash
amcm shell
amcm migrate
amcm backfill_vehicle_stats --sleep 0.1
```

Or manually:

```bash
su -s /bin/sh amc -c \
  'DJANGO_SETTINGS_MODULE=amc_backend.settings amc-manage <command>'
```

For shell queries:
```bash
su -s /bin/sh amc -c \
  'DJANGO_SETTINGS_MODULE=amc_backend.settings amc-manage shell -c "<python code>"'
```

> [!IMPORTANT]
> Django commands must run as the `amc` user and require `DJANGO_SETTINGS_MODULE=amc_backend.settings`.

### Database access

```bash
su -s /bin/sh amc -c 'psql'
```

## Services on asean-mt-server

| Service | systemd unit | Description |
|---------|-------------|-------------|
| Django API | `amc-backend` | uvicorn ASGI server |
| Worker + Discord Bot | `amc-worker` | arq worker with Discord bot in a ThreadPoolExecutor |
| Dummy Server | `dummy-server` | Test/dummy server |
| PostgreSQL | `postgresql` | Database with PostGIS, TimescaleDB, pg_partman |
| Redis | `redis-amc-backend` | Task queue and caching |
| Log Listener | `rsyslogd` | RELP log ingestion from game servers |

### amc-worker architecture

The `amc-worker` process runs `arq` which:
1. **On startup**: creates an `aiohttp` session pool and starts the **Discord bot** in a `ThreadPoolExecutor`
2. **Cron jobs**: `monitor_jobs`, `monitor_webhook`, `monitor_locations`, `send_event_embeds`, etc.
3. **Task queue**: processes `process_log_line` tasks from Redis
4. **Discord bot**: loads cogs (`JobsCog`, `EventsCog`, `RoleplayCog`, etc.) with their own `tasks.loop` schedules

> [!CAUTION]
> The Discord bot runs in a separate thread inside the arq worker. If the bot crashes or a cog's `tasks.loop` dies from an unhandled exception, the arq worker process will continue running normally — only the bot/cog functionality stops silently. Check for both arq cron output AND Discord-specific logs when debugging.

## Other Host-Level Services

- `motortown-server` — Main Motor Town game server
- `motortown-server-containers-test` — Test game server container
- `motortown-server-containers-event` — Event game server container

## Troubleshooting Checklists

### "Discord channel not updating"

1. Check if `amc-worker` is running: `systemctl status amc-worker`
2. Check recent logs for the specific loop: `journalctl -u amc-worker --since '1 hour ago' | grep -i "<loop_name>"`
3. Look for Discord errors: `journalctl -u amc-worker --since '3 days ago' | grep -i "discord.*error\|DiscordServerError\|Traceback"`
4. If a `tasks.loop` died, restart the worker: `systemctl restart amc-worker`

### "arq cron job not running"

1. Check worker status and recent logs
2. Look for Python exceptions in journal
3. Restart if needed
