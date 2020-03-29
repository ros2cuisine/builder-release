# https://github.com/ichbestimmtnicht/docker-autobuild-release
# Template created 2020 by Ludwig Werner Döhnert
# This work is licensed under the Creative Commons Attribution 4.0 International License.
# To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.

# Set global environment variables
ARG SRC_NAME
ARG SRC_REPO
ARG SRC_TAG
ARG ROS_DISTRO

FROM scratch AS buildcontext

COPY . .

# Setup Qemu
FROM alpine AS qemu

ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz

RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

# Setup arguments for the bundle image
ARG SRC_NAME
ARG SRC_REPO
ARG SRC_TAG

# Pull image
FROM ${SRC_NAME}/${SRC_REPO}:${SRC_TAG}-arm32v7 AS bundle

COPY --from=qemu qemu-arm-static /usr/bin

ARG ROS_DISTRO

# These are variables are also avaivable in the build image
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
