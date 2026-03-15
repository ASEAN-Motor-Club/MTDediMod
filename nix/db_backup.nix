{
  pkgs,
  config,
  ...
}: let
  backupDir = "/var/lib/amc-backups";

  # Discord notification helper
  discordNotify = pkgs.writeShellScript "discord-notify" ''
    WEBHOOK_URL="$1"
    MESSAGE="$2"
    ${pkgs.curl}/bin/curl -s -X POST "$WEBHOOK_URL" \
      -H "Content-Type: application/json" \
      -d "{\"content\": \"$MESSAGE\"}" > /dev/null 2>&1 || true
  '';

  pg_dump = "${pkgs.postgresql_16}/bin/pg_dump";
  pg_restore = "${pkgs.postgresql_16}/bin/pg_restore";

  # Helper script that runs inside the container as postgres user
  restoreHelper = pkgs.writeShellScript "amc-db-restore-helper" ''
    DUMP_FILE="$1"
    psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'amc' AND pid <> pg_backend_pid();"
    dropdb --if-exists amc
    createdb amc
    ${pg_restore} -j 4 -d amc "$DUMP_FILE"
  '';
in {
  # Ensure backup directory exists on the host
  systemd.tmpfiles.rules = [
    "d ${backupDir} 0700 root root -"
  ];

  # --- Daily database backup ---
  # Runs pg_dump inside the amc-backend container, writes to host filesystem
  systemd.services.amc-dbBackup = {
    path = ["/run/current-system/sw"];
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
    script = ''
      set -eo pipefail
      export $(cat ${config.age.secrets.backend.path} | xargs)
      today=$(date +"%Y%m%d")
      dumpFile="${backupDir}/amc.$today.dump"

      echo "Starting database backup: $dumpFile"

      RC=0
      nixos-container run amc-backend -- \
        su -s /bin/sh postgres -c "${pg_dump} -Fc amc" \
        > "$dumpFile" || RC=$?

      if [ $RC -eq 0 ]; then
        SIZE=$(stat -c%s "$dumpFile" 2>/dev/null || stat -f%z "$dumpFile")
        echo "Backup complete: $((SIZE / 1048576))MB"
        ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "✅ **[AMC DB Backup]** Daily backup completed: \`amc.$today.dump\` ($((SIZE / 1048576))MB)"

        # Rotate: keep last 7 days
        find ${backupDir} -name "amc.*.dump" -mtime +7 -delete
      else
        echo "Backup failed!"
        ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "❌ **[AMC DB Backup]** Daily backup FAILED for \`$today\`"
        exit 1
      fi
    '';
    unitConfig = {
      OnFailure = "amc-dbBackupFailureNotify.service";
    };
  };

  # Crash-level failure notification
  systemd.services.amc-dbBackupFailureNotify = {
    path = ["/run/current-system/sw"];
    serviceConfig.Type = "oneshot";
    script = ''
      export $(cat ${config.age.secrets.backend.path} | xargs)
      ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "🚨 **[AMC DB Backup]** Service crashed! Check \`journalctl -u amc-dbBackup\` immediately."
    '';
  };

  # --- Backup verification ---
  systemd.services.amc-dbBackupVerify = {
    path = ["/run/current-system/sw"];
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
    script = ''
      set -eo pipefail
      export $(cat ${config.age.secrets.backend.path} | xargs)
      today=$(date +"%Y%m%d")
      dumpFile="${backupDir}/amc.$today.dump"

      if [ ! -f "$dumpFile" ]; then
        ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "❌ **[AMC DB Verify]** Backup file not found: \`amc.$today.dump\`"
        exit 1
      fi

      FILE_SIZE=$(stat -c%s "$dumpFile" 2>/dev/null || stat -f%z "$dumpFile" 2>/dev/null)

      # Minimum expected size (5MB) — AMC DB is large (175M+ rows in CharacterLocation alone)
      MIN_SIZE=5242880
      if [ "$FILE_SIZE" -lt "$MIN_SIZE" ]; then
        ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "⚠️ **[AMC DB Verify]** Backup suspiciously small: \`$FILE_SIZE bytes\` (expected >5MB)"
        exit 1
      fi

      echo "Running pg_restore --list (table of contents check)..."
      RC=0
      ${pg_restore} --list "$dumpFile" > /dev/null 2>&1 || RC=$?
      if [ $RC -eq 0 ]; then
        TABLE_COUNT=$(${pg_restore} --list "$dumpFile" 2>/dev/null | grep -c "TABLE DATA" || true)
        echo "Backup verified: $TABLE_COUNT tables, $FILE_SIZE bytes"
        ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "✅ **[AMC DB Verify]** Backup integrity OK: \`$TABLE_COUNT tables\`, \`$((FILE_SIZE / 1048576))MB\`"
      else
        ${discordNotify} "$DISCORD_ERRORS_WEBHOOK" "❌ **[AMC DB Verify]** Backup is CORRUPT: pg_restore --list failed for \`amc.$today.dump\`"
        exit 1
      fi
    '';
  };

  # --- Restore service ---
  # Usage: systemctl start amc-dbRestore@20260315
  systemd.services."amc-dbRestore@" = {
    path = ["/run/current-system/sw"];
    environment = {
      BACKUP_DATE = "%i";
    };
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
    script = ''
      dumpFile="${backupDir}/amc.$BACKUP_DATE.dump"
      if [ ! -f "$dumpFile" ]; then
        echo "Backup file not found: $dumpFile"
        exit 1
      fi

      echo "Restoring from: $dumpFile"
      echo "WARNING: This will drop and recreate the amc database!"

      # Copy dump into container-accessible path, restore, then clean up
      cp "$dumpFile" /var/lib/nixos-containers/amc-backend/tmp/restore.dump
      nixos-container run amc-backend -- \
        su -s /bin/sh postgres -c "${restoreHelper} /tmp/restore.dump"
      rm -f /var/lib/nixos-containers/amc-backend/tmp/restore.dump

      echo "Restore complete."
    '';
  };

  # --- Timers ---
  systemd.timers.amc-dbBackup = {
    wantedBy = ["timers.target"];
    partOf = ["amc-dbBackup.service"];
    timerConfig.OnCalendar = "*-*-* 4:00:00";
    timerConfig.Persistent = true;
  };
  systemd.timers.amc-dbBackupVerify = {
    wantedBy = ["timers.target"];
    partOf = ["amc-dbBackupVerify.service"];
    timerConfig.OnCalendar = "*-*-* 5:00:00";
    timerConfig.Persistent = true;
  };
}
