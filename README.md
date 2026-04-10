# Jo-zotac
Jo-zotac is a dockerfile image containing all the software needed to interface with AgileX Bunker Pro and its sensors (Jo). 

## Installation
### Docker configuration
To correctly install the docker with GPU access, these steps need to be followed:
1. Install Docker Engine with their [guide](https://docs.docker.com/engine/install/ubuntu/)
2. Allow Docker usage as non-root user ([guide](https://docs.docker.com/engine/install/linux-postinstall/))
3. Correctly install [nVidia drivers](https://github.com/oddmario/NVIDIA-Ubuntu-Driver-Guide)
4. Install the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

After docker is correctly installed, run
```bash
docker compose up --build
```
After the docker is built, run:
```bash
docker compose up -d && docker compose exec jo-zotac bash -c "nvidia-smi"
```
to confirm that everything works fine. 

## Usage
The dockerfile already clones and built all the packages needed to interface with the sensors. The `jo_bringup` package is instead shared as a volume and built when the docker is started up as a symlink. This allows to edit the launch or config files without the need to rebuild the docker or the packages.

To run the bringup package, open a terminal and run 
```bash
docker compose up
```
Then, in another terminal run
```bash
docker compose exec jo-zotac ros2 launch jo_bringup jo_bringup.launch.py
```
By default this will launch the IMU interface and the lidar interface. It is possible to customize what is launched using the provided parameters. These are booleans that decide wether that module is launched or not.
### Module launch file parameters
- `imu:=<bool>` - Xsense IMU module.
- `gnss:=<bool>` - Xsense GNSS module. Needs the IMU module to be loaded and a working internet access.
- `lidar:=<bool>` - Velodyne VLP16 Lidar module. 
- `front_cam:=<bool>` - Realsense D455 module. It is tied to the camera serial number.
- `back_cam:=<bool>` - Realsense D455 module. It is tied to the camera serial number.
- `bunker:=<bool>` - Agilex Bunker Pro CAN interface module. It brings up the CAN interface when launched and brings it down when closed.
- `glim:=<bool>` - GLIM SLAM module. 
- `rviz:=<bool>` - rViz visualization

**Note** that, as of now launching with ```bunker:=true``` may not work. The node seems to fail a couple of times before correctly launchin, so it's suggested to launch it in a different console.

### Handy aliases
Given that the launch commands can be quite long, some aliases to quickly run some combinations of the perception stack have been added to the bashrc.
+ ```light_stack``` - Launches the perception stack with imu and lidar
+ ```full_stack``` - Launches the perception stack with imu, lidar, front and back camera, GNSS and glim
+ ```glim_only``` - Only launches glim SLAM
+ ```glim_sim``` - Launches glim SLAM with ```use_sim_time:=true```
+ ```offline_viewer``` - Opens glim's offline viewer to analyze created maps
+ ```bunker_only``` - Launches Bunker command interface
+ ```save_map <map_name>``` - Saves the last map created by glim in the folder ```saved_maps/YYYYMMDD_HHMMSS_<map_name>```
+ ```localization``` - Launches local odometry module
+ ```localization_gps``` - Launches global odometry with dueal EKF configuration with GPS
+ ```navigation``` - Launches nav2 stack configured to work with local odometry
+ ```navigation_gps``` - Launches nav2 stack configured to work with global odometry and GPS
+ ```record_all <bag_name>``` - Records a rosbag of **all** topics and saves it in the folder ```bags/YYYYMMDD_HHMMSS_<bag_name>```


### Other launch file parameters
- `imu_param:=<path/to/yaml>` - Provides a path for the IMU config file.
- `gnss_param:=<path/to/yaml>` - Provides a path for the IMU GNSS config file.
- `glim_param:=<path/to/config/folder>` - Provides a path for GLIM config folder.

If none of these parameters are provided, they default to the config files present in the `config` folder. 

#### Minimal working SLAM example
Run inside the docker
```bash
ros2 launch jo_bringup jo_bringup.launch.py glim:=true
```
or simply
```bash
light_stack glim:=true
```


