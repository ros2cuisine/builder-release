# Dummy Dockerfile because hooks aren't working with a custom Filename
# Have a look into the hooks folder to see them per arch
# https://gitlab.com/ros2cuisine/templates/builder/tree/master/hooks/

FROM scratch AS buildcontext

COPY . .

# Pull the image
FROM ros2cuisine/bundler as bundle

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
