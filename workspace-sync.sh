#!/usr/bin/env bash

INIT_WORKSPACE_FOLDER=/init_workspace
WORKSPACE_FOLDER=/workspace

user=$(whoami)

if ! [[ "$(ls -A ${WORKSPACE_FOLDER})" ]]; then
  sudo cp -R ${INIT_WORKSPACE_FOLDER}/* ${WORKSPACE_FOLDER}
  sudo chown -R ${user}:${user} ${WORKSPACE_FOLDER}
fi

exec "$@"