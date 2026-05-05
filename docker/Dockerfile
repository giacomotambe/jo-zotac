# ============================================================
# STAGE 1: Build Open3D from source (required by onboard_detector)
# ============================================================
FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-dev \
    python3-pip \
    libgl1-mesa-dev \
    libx11-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libeigen3-dev \
    libomp-dev \
    xorg-dev \
    libxcb-shm0 \
    libglu1-mesa-dev \
    libc++-dev \
    libc++abi-dev \
    libsdl2-dev \
    libxi-dev \
    libtbb-dev \
    libosmesa6-dev \
    libudev-dev \
    autoconf \
    libtool \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/isl-org/Open3D && cd Open3D && mkdir build && cd build && cmake .. && make -j$(nproc)
RUN cd Open3D/build && make install DESTDIR=/open3d-install

# ============================================================
# STAGE 2: Main image
# ============================================================
FROM osrf/ros:jazzy-desktop-full

# Copy Open3D from builder stage
COPY --from=builder /open3d-install/ /

ENV GZ_VERSION=harmonic
ARG DISTRO=jazzy

RUN apt update -y \
    && apt install -y pipx \
    nano \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt update -y \
    && apt install -y ros-${DISTRO}-plotjuggler \
    ros-${DISTRO}-joint-state-publisher \
    ros-${DISTRO}-joint-state-publisher-gui \
    ros-${DISTRO}-gz-ros2-control \
    ros-${DISTRO}-teleop-twist-joy \
    ros-${DISTRO}-joy \
    ros-${DISTRO}-pinocchio \
    ros-${DISTRO}-ros2-control \
    ros-${DISTRO}-ros2-controllers \
    ros-${DISTRO}-xacro \
    ros-${DISTRO}-rosbag2-storage-mcap \
    ros-${DISTRO}-rmw-cyclonedds-cpp \
    ros-${DISTRO}-nmea-msgs \
    ros-${DISTRO}-mavros-msgs \
    ros-${DISTRO}-realsense2-camera \
    ros-${DISTRO}-realsense2-description \
    ros-${DISTRO}-nav2-common \
    ros-${DISTRO}-nav2-controller \
    ros-${DISTRO}-nav2-smoother \
    ros-${DISTRO}-nav2-planner \
    ros-${DISTRO}-nav2-behaviors \
    ros-${DISTRO}-nav2-bt-navigator \
    ros-${DISTRO}-nav2-waypoint-follower \
    ros-${DISTRO}-nav2-velocity-smoother \
    ros-${DISTRO}-nav2-lifecycle-manager \
    ros-${DISTRO}-nav2-dwb-controller \
    ros-${DISTRO}-nav2-navfn-planner \
    ros-${DISTRO}-nav2-rviz-plugins \
    ros-${DISTRO}-nav2-graceful-controller \
    ros-${DISTRO}-robot-localization \
    zenity \
    python3-rosdep \
    software-properties-common \
    ca-certificates \
    gnupg \
    wget \
    libmetis-dev \
    libasio-dev \
    libpcap0.8-dev \
    iproute2 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Create a non-root user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN if id -u ${USER_UID} ; then userdel `id -un ${USER_UID}` ; fi
RUN groupadd --gid ${USER_GID} ${USERNAME}
RUN useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && apt update \
    && apt install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}



# --- CUDA repo (Ubuntu 24.04) ---
RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
 && dpkg -i cuda-keyring_1.1-1_all.deb \
 && wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin \
 && mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600

ENV CUDAToolkit_ROOT=/usr/local/cuda

RUN curl -s https://koide3.github.io/ppa/setup_ppa.sh | sudo bash
RUN sudo add-apt-repository -y ppa:koide3/iridescence
RUN apt update -y \
    && apt install -y libiridescence-dev \
    libgtsam-points-cuda13.1-dev \
    cuda-cudart-13-0 \
    cuda-nvcc-13-0 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ============================================================
# OPEN3D RUNTIME COMPATIBILITY
# ============================================================
# Install libc++/libc++abi runtime needed by Open3D
RUN apt-get update && apt-get install -y \
    libc++1 \
    libc++abi1 \
    libtbb12 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Open3D in /usr/local may reference LLVM-18 libc++ absolute paths.
# Create compatibility symlinks so CMake/Make can resolve them.
RUN mkdir -p /usr/lib/llvm-18/lib && \
    ln -sf /usr/lib/x86_64-linux-gnu/libc++.so.1 /usr/lib/llvm-18/lib/libc++.so.1 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libc++abi.so.1 /usr/lib/llvm-18/lib/libc++abi.so

# Open3D installs a private TBB in /usr/local/lib that conflicts with the
# distro-provided libtbb.so.12 and causes CMake RPATH warnings.
# Replace with symlinks to system TBB so Open3D's CMake config works
# but uses the system library at runtime.
RUN rm -f /usr/local/lib/libtbb.so* && \
    ln -sf /usr/lib/x86_64-linux-gnu/libtbb.so.12.11 /usr/local/lib/libtbb.so.12.12 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libtbb.so.12 /usr/local/lib/libtbb.so.12 && \
    ln -sf /usr/lib/x86_64-linux-gnu/libtbb.so /usr/local/lib/libtbb.so

# ============================================================
# PYTHON ML DEPENDENCIES (required by onboard_detector)
# ============================================================
RUN apt-get update && apt-get remove -y \
    python3-sympy \
    python3-mpmath \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages --ignore-installed pip setuptools wheel

# PyTorch with CUDA support (cu118) - needed for YOLO detector
# Falls back gracefully if network is unavailable
RUN python3 -m pip install --no-cache-dir --break-system-packages --ignore-installed \
    --retries 10 \
    --timeout 300 \
    torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu118 || \
    echo "WARNING: PyTorch installation failed. YOLO detector will not work, but ICP calibration will."

# Computer vision and scientific stack from apt
RUN apt-get update && apt-get install -y \
    python3-opencv \
    python3-scipy \
    python3-sklearn \
    python3-matplotlib \
    python3-pil \
    python3-yaml \
    python3-tqdm \
    python3-requests \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --break-system-packages --ignore-installed \
    --trusted-host pypi.org \
    --trusted-host files.pythonhosted.org \
    --trusted-host pypi.python.org \
    "numpy>=2.0" \
    ultralytics


USER ros
RUN sudo usermod -aG dialout ros
WORKDIR /home/$USERNAME/
RUN mkdir src

RUN rosdep update

# VELODYNE
RUN cd src/ && git clone https://github.com/ros-drivers/velodyne.git

# IMU
RUN cd src && git clone --branch ros2 https://github.com/mlisi1/Xsens_MTi_ROS_Driver_and_Ntrip_Client.git

# GLIM — mounted as volume, not cloned
# RUN cd src && git clone https://github.com/koide3/glim_ros2.git
# RUN cd src && git clone https://github.com/koide3/glim.git

# Agilex Bunker
RUN cd src && git clone https://github.com/mlisi1/ugv_sdk.git
RUN cd src && git clone -b jazzy https://github.com/agilexrobotics/bunker_ros2.git

RUN cd src && git clone https://github.com/sutharsan-311/nav2_config.git


RUN cd src && git clone https://github.com/introlab/rtabmap.git
RUN cd src &&git clone --branch ros2 https://github.com/introlab/rtabmap_ros.git
# rosdep update && rosdep install --from-paths src --ignore-src -r -y
RUN export MAKEFLAGS="-j6" # Can be ignored if you have a lot of RAM (>16GB)
# colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# RUN rosdep install --from-paths src --ignore-src -r -y

SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/jazzy/setup.bash \
 && colcon build --cmake-args -DRTABMAP_SYNC_MULTI_RGBD=ON -DRTABMAP_SYNC_USER_DATA=ON -DCMAKE_BUILD_TYPE=Release

COPY docker/entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh

COPY docker/save_map.bash /save_map.bash
COPY docker/record_all.bash /record_all.bash
COPY docker/utilities.sh /etc/utilities.sh
RUN echo 'source /etc/utilities.sh' >> ~/.bashrc


ENTRYPOINT ["/entrypoint.sh"]
