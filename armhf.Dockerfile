# Set environment variables
ARG ROS_DISTRO=eloquent
ARG GITLAB_USERNAME=ros2cuisine
ARG DOCKERHUB_SOURCE_USER=arm32v7
ARG FLAVOR=ros

#Setup Qemu
FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz

RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

#pull image
FROM ${DOCKERHUB_SOURCE_USER}/${FLAVOR}:${ROS_DISTRO}

COPY --from=qemu qemu-arm-static /usr/bin

ARG VCS_REF
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
    && mkdir -p /cuisine/workspaces/output

# Choose the directory for builds
WORKDIR /cuisine/workspaces

# Finishing the image
ENTRYPOINT ["/opt/ros/$ROS_DISTRO/ros_entrypoint.sh"]
CMD ["bash"]

LABEL org.label-schema.name="ros2cuisine/builder:eloquent-arm32v7" \
      org.label-schema.description="The Minimal build image for cuisine Docker images cycle" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://hub.docker.com/ros2cuisine/builder" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1" \
      org.label-schema.maintainer="cuisine-dev@ichbestimmtnicht.de" \
      org.label-schema.url="https://github.com/ros2cuisine/builder-release/" \
      org.label-schema.vendor="ichbestimmtnicht" \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.docker.cmd="docker run -d ros2cuisine/builder"
