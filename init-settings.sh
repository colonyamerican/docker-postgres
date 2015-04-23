#!/bin/sh

echo "ssl = on" >> $PGDATA/postgresql.conf
echo "work_mem = 8MB" >> $PGDATA/pg_hba.conf
echo "maintenance_work_mem = 40MB"  >> $PGDATA/pg_hba.conf
echo "checkpoint_segments = 20" >> $PGDATA/pg_hba.conf
