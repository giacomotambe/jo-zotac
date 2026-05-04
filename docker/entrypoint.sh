#!/usr/bin/env bash
set -e

source /opt/ros/jazzy/setup.bash

colcon build --packages-select jo_msgs jo_bringup glim glim_ros --symlink-install

source install/setup.bash

exec "$@"
