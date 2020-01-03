# Set environment variables
ARG SRC_NAME
ARG SRC_REPO
ARG SRC_TAG

# Pull the image
FROM ${SRC_NAME}/${SRC_REPO}:${SRC_TAG} as bundle

ARG ROS_DISTRO

# These are avaivable in the build image
ENV ROS_DISTRO ${ROS_DISTRO}
ENV DEBIAN_FRONTEND noninteractive

# Install barebones
RUN apt-get update \
    && apt-get install -y -q \
        # Colcon Ros Bundle
        python3-apt \
        # msgs
        ros-${ROS_DISTRO}-sensor-msgs \
        ros-${ROS_DISTRO}-nav-msgs \
        ros-${ROS_DISTRO}-geometry-msgs \
        # ROS Devs
        ros-${ROS_DISTRO}-rosidl-default-generators \
        # Maybe outdated and not used anymoore
        ros-${ROS_DISTRO}-ament-cmake* \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -U \
        colcon-ros-bundle \
    # Create Working directory for builds
    && mkdir -p /cuisine/workspaces

# Choose the directory for builds
WORKDIR /cuisine/workspaces

# Finishing the image
ENTRYPOINT ["/ros_entrypoint.sh"]
# Finishing the image
CMD ["bash"]
