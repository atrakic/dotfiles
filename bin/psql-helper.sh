#!/usr/bin/env bash

set -e

# Usage: link this file with any of switchase bellow.
# For remote connectsions, make sure you have proper env vars: https://www.postgresql.org/docs/10.6/libpq-envars.html

if [ "${0##*/}" = "psql-helper.sh" ]; then
  echo '$(basename $0): This script should not be run like this' 1>&2
  exit 1
fi

main() {
  thisfile="${0##*/}"
  do=$(basename "$thisfile" | cut -d. -f1)

  case "$do" in
  psql_autovacuum_is_running)
    psql -tAc "SELECT datname, usename, pid, state, wait_event, current_timestamp - xact_start AS xact_runtime, query FROM pg_stat_activity WHERE upper(query) like '%VACUUM%' ORDER BY xact_start;"
    ;;
  psql_current_database)
    psql -tAc 'SELECT current_database();'
    ;;
  pg_roles)
    psql -tAc "SELECT rolname FROM pg_roles;"
    ;;
  pg_databases)
    psql -tAc "select * from pg_database;"
    ;;
  pg_stat_activity)
   psql -tAc "SELECT * FROM pg_stat_activity ORDER BY pid;"
   ;;
  psql_database_size)
    psql -tAc "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;"
    ;;
  psql_settings_not_default_or_override)
    psql -tAc "SELECT name, current_setting(name), SOURCE FROM pg_settings WHERE SOURCE NOT IN ('default', 'override');"
    ;;
  psql_settings)
    psql -tAc 'SELECT name, setting, boot_val, reset_val, unit FROM pg_settings ORDER by name;'
    ;;
  psql_current_user)
    psql -tAc 'SELECT current_user;'
    ;;
  psql_version)
    psql -tAc 'SELECT version();'
    ;;
  esac
}

main "$@"
