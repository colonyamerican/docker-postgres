#!/bin/sh

openssl req -nodes -newkey rsa:2048 \
  -keyout $PGDATA/server.key \
  -out $PGDATA/server.csr \
  -subj "/C=/ST=/O=/OU=/CN=/"

openssl req -x509 \
  -in $PGDATA/server.csr \
  -text \
  -key $PGDATA/server.key \
  -out $PGDATA/server.crt

echo "ssl = on" >> $PGDATA/postgresql.conf
echo "hostssl all all 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf

chmod og-rwx $PGDATA/server.key
chown -R postgres:postgres $PGDATA/*
