# The Minimal Image Building preparation for the Cuisine Development Cycle

## Instructions

### Pull the latest image

```bash
docker pull ros2cuisine/builder:eloquent-x86_64
```

### Example usage

```Dockerfile
ARG GITLAB_USERNAME=ros2cuisine
ARG TARGET_ARCH=x86_64
ARG ROS_DISTRO=eloquent

FROM openfaas/classic-watchdog:0.18.6 as watchdog
FROM ${GITLAB_USERNAME}/builder:${ROS_DISTRO}-${TARGET_ARCH} as builder
# Build instructions like
# copy the hole repo into the build image
COPY . .
# Update & Upgrade
# We always wanna upgrade before a build that devs have to stick versions rather then let users resolve this semself
RUN apt update \
    && apt upgrade -y \
    # Source ros
    && . /opt/ros/eloquent/setup.sh \
    # Build the workspace
    && colcon build \
    # Begin Bundling
    && colcon bundle

# End of builder image
FROM ${GITLAB_USERNAME}/bundler:${ROS_DISTRO}-${TARGET_ARCH} as bundled
# Have a look at https://gitlab.com/ros2cuisine/bundler to learn how to bundle
#    COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
#    COPY --from=builder /cuisine/workspaces/bundle/output.tar output/
# are used to copy needed things
```
