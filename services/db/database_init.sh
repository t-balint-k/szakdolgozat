#!/bin/sh

initdb -D /container-data/
echo "host all all 0.0.0.0/0 md5" >> /container-data/pg_hba.conf
echo "listen_addresses = '*'" >> /container-data/postgresql.conf
