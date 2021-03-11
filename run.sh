#!/usr/bin/dumb-init /bin/sh

set -x
echo "Running /run.sh with the following ENV"
echo $(env)

echo "Starting Wetty server on ${REMOTE_SSH_SERVER}:${WETTY_PORT}"
npm start --prefix /wetty-app -p ${WETTY_PORT}
