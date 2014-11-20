#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then

  if [ -z "$(ls -A "$PGDATA")" ]; then

    chown -R postgres "$PGDATA"

    sudo -E -u postgres /usr/lib/postgresql/9.3/bin/initdb

    sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

    sudo -E -u postgres -- /usr/lib/postgresql/9.3/bin/postgres --single postgres -E <<-EOSQL
CREATE DATABASE "$POSTGRES_DB"
EOSQL

    pass="PASSWORD '$POSTGRES_PASS'"

    sudo -E -u postgres -- /usr/lib/postgresql/9.3/bin/postgres --single postgres -E <<-EOSQL
CREATE USER "$POSTGRES_USER" WITH SUPERUSER $pass
EOSQL
    echo "host all all 0.0.0.0/0 md5" >> "$PGDATA"/pg_hba.conf

    if [ -d /docker-entrypoint-initdb.d ]; then
      for f in /docker-entrypoint-initdb.d/*.sh; do
        [ -f "$f" ] && . "$f"
      done
    fi
  fi

  sudo -E -u postgres /usr/lib/postgresql/9.3/bin/postgres -D "$PGDATA"
fi

exec "$@"
