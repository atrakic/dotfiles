#!/usr/bin/env bash

set -e

# Usage: link this file with any of switcase bellow.
# For remote connections, make sure you have proper env vars: https://www.postgresql.org/docs/10.6/libpq-envars.html

if [ "${0##*/}" = "psql-helper.sh" ]; then
  echo "$(basename $0): This script should not run like this" 1>&2
  exit 1
fi

main() {
  thisfile="${0##*/}"
  do=$(basename "$thisfile" | cut -d. -f1)
  arg="-tAc"

  case "$do" in
  psql_autovacuum_is_running)
    psql "$arg" "SELECT datname, usename, pid, state, wait_event, current_timestamp - xact_start AS xact_runtime, query FROM pg_stat_activity WHERE upper(query) like '%VACUUM%' ORDER BY xact_start;"
    ;;
  psql_current_database)
    psql "$arg" 'SELECT current_database();'
    ;;
  pg_roles)
    psql "$arg" "SELECT rolname FROM pg_roles;"
    ;;
  pg_databases)
    psql "$arg" "select * from pg_database;"
    ;;
  pg_stat_activity)
   psql "$arg" "SELECT * FROM pg_stat_activity ORDER BY pid;"
   ;;
  psql_database_size)
    psql "$arg" "SELECT pg_database.datname, pg_database_size(pg_database.datname), pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database ORDER BY pg_database_size DESC;"
    ;;
  psql_settings_not_default_or_override)
    psql "$arg" "SELECT name, current_setting(name), SOURCE FROM pg_settings WHERE SOURCE NOT IN ('default', 'override');"
    ;;
  psql_extensions_available)  
   psql "$arg" "SELECT * FROM pg_available_extensions;"
   ;;
  psql_extensions_installed)
   psql "$arg" "SELECT extname FROM pg_extension;"
   ;;
  psql_settings)
    psql "$arg" 'SELECT name, setting, boot_val, reset_val, unit FROM pg_settings ORDER by name;'
    ;;
  psql_current_user)
    psql "$arg" 'SELECT current_user;'
    ;;
  psql_version)
    psql "$arg" 'SELECT version();'
    ;;
  esac
}

main "$@"
