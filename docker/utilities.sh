source /opt/ros/jazzy/setup.bash
source /home/ros/install/setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
alias light_stack='ros2 launch jo_bringup jo_bringup.launch.py'
alias glim_only='ros2 launch jo_bringup jo_bringup.launch.py imu:=false lidar:=false glim:=true'
alias glim_sim='ros2 launch jo_bringup jo_bringup.launch.py imu:=false lidar:=false glim:=true use_sim_time:=true'
alias full_stack='ros2 launch jo_bringup jo_bringup.launch.py glim:=true front_cam:=true back_cam:=true gnss:=true'
alias bunker_only='ros2 launch jo_bringup jo_bringup.launch.py imu:=false lidar:=false bunker:=true'
alias offline_viewer='ros2 run glim_ros offline_viewer'
source /save_map.bash
source /record_all.bash
alias no_gpu='__NV_PRIME_RENDER_OFFLOAD=0 __GLX_VENDOR_LIBRARY_NAME='

alias localization='ros2 launch jo_navigation localization.launch.py'
alias localization_gps='ros2 launch jo_navigation localization_gps.launch.py'

alias navigation='ros2 launch jo_navigation navigation_local.launch.py rviz:=true'
alias navigation_gps='ros2 launch jo_navigation navigation_gps.launch.py rviz:=true'

alias visodom='ros2 launch jo_navigation visodom.launch.py'
alias detector='ros2 launch onboard_detector run_detector.launch.py'
alias description='ros2 launch jo_description description.launch.py'


# LV-DOT Running 
alias detector='ros2 launch onboard_detector run_detector.launch.py'
# LV-DOT Runnig when running on bags
alias detector_bag='ros2 launch onboard_detector run_detector.launch.py odom_pub:=true'


