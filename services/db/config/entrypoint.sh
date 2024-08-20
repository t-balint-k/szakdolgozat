#!/bin/sh

# ENTRYPOINT SCRIPT FOR THE THESIS DATABASE - BÁLINT TÓTH - 2024. 08. 19 #

umask 027

trap 'kill -TERM $PID' TERM INT
postgres -D /container-data &
PID=$!
wait $PID
