#!/usr/bin/env bash

INIT_WORKSPACE_FOLDER=/init_workspace
WORKSPACE_FOLDER=/workspace
WS_NAME=/ROS-Gazebo-jetbot-ws

user=$(whoami)

if ! [[ "$(ls -A ${WORKSPACE_FOLDER}/${WS_NAME})" ]]; then
  sudo cp -R ${INIT_WORKSPACE_FOLDER}/* ${WORKSPACE_FOLDER}/${WS_NAME}
  sudo chown -R ${user}:${user} ${WORKSPACE_FOLDER}/${WS_NAME}
  sudo rm -R ${INIT_WORKSPACE_FOLDER}
fi

exec "$@"