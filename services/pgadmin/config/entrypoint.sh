#!/bin/sh

# ENTRYPOINT SCRIPT FOR THE PGADMIN SLIM CLIENT - BÁLINT TÓTH - 2024. 09. 26 #

umask 027

trap 'kill -TERM $PID' TERM INT
sleep infinity &
PID=$!
wait $PID
