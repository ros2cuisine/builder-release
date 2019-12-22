# Set environment variables
ARG ROS_DISTRO=eloquent
ARG FUNCTION_NAME=builder
ARG BUILD_REPO=bundler
ARG BUILD_TAG_NAME=eloquent-amd64-staged
ARG BUILD_USER=ros2cuisine

#Setup Qemu
FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz

RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

ARG BUILD_USER=ros2cuisine
ARG BUILD_REPO=bundler
ARG BUILD_TAG_NAME=eloquent-amd64-staged

# Pull the image
FROM ${BUILD_USER}/${BUILD_REPO}:${BUILD_TAG_NAME} as bundle


COPY --from=qemu qemu-arm-static /usr/bin

ARG ROS_DISTRO=eloquent

# These are avaivable in the build image
ENV ROS_DISTRO ${ROS_DISTRO}
ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt install -q -y \
        wget \
        curl \
        gnupg2 \
        lsb-release \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - \
    && wget http://packages.osrfoundation.org/gazebo.key \
    && apt-key add gazebo.key \
    && rm -rf gazebo.key \
    && apt-get update -q \
    && apt upgrade -y -q \
    # Install barebones
    && sudo apt install -y -q \
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

CMD ["bash"]
