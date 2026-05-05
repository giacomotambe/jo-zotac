#!/usr/bin/env bash
set -e

sudo ip link set can0 up type can bitrate 500000 2>/dev/null || echo "CAN interface not found"

source /opt/ros/jazzy/setup.bash

colcon build \
  --packages-select jo_msgs jo_bringup glim glim_ros jo_description jo_navigation \
  --symlink-install

source install/setup.bash
source /save_map.bash

exec "$@"
