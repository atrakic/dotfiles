#!/bin/bash

function ls_pg()
{
    db=$*
    echo "[$db]:"
    COUNT=0
    for table in $(psql -tc "select table_name from information_schema.tables where table_schema='public' and table_type='BASE TABLE'" "$db" 2>/dev/null);
    do
        let COUNT++
        RCOUNT=$(psql -tc "select count(*) from $table" -d "$db");
        echo "$COUNT --> $table: count: " "$RCOUNT"
    done
}

if [ "$*" ];
then
    dbs=$*
	  for db in $dbs; do ls_pg "$db"; done
else
    for db in $(psql template1 -tc "select datname from pg_database"); do ls_pg "$db"; done
fi
