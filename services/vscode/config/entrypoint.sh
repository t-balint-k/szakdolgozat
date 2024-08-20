#!/bin/sh

umask 027
trap 'kill -TERM $PID' TERM INT
code-server --disable-telemetry --config /container-config/config.yaml --user-data-dir /container-data/user-data/ --extensions-dir /container-data/extensions/ --app-name 'CODE XERVER' --welcome-text 'FANCY WELCOME TEXT' &
PID=$!
wait $PID
