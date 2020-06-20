# https://github.com/ichbestimmtnicht/docker-autobuild-release
# Template created 2020 by Ludwig Werner Döhnert
# This work is licensed under the Creative Commons Attribution 4.0 International License.
# To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.

# Set global environment variables
ARG SRC_NAME
ARG SRC_REPO
ARG SRC_TAG

FROM scratch AS buildcontext

COPY . .

# Pull the image
FROM ${SRC_NAME}/${SRC_REPO}:${SRC_TAG}-amd64 as bundle

# Install barebones
RUN apt-get update \
    && apt-get install -y -q \
        python3-pip \
        # Colcon ROS Bundle
        python3-colcon-common-extensions \
        python3-colcon-ros \
        # ROS Build pkg's
        ros-${ROS_DISTRO}-.*-msgs \
        ros-${ROS_DISTRO}-ament-cmake-.* \
    && rm -rf /var/lib/apt/lists/*
