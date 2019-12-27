# The Minimal Image Building preparation for the Cuisine Development Cycle

## Instructions

### Pull the latest image

```bash
docker pull ros2cuisine/builder
```

### Example usage

```Dockerfile
FROM openfaas/classic-watchdog:0.18.6 as watchdog

FROM ros2cuisine/builder as builder

# Build instructions like
# copy the hole repo into the build image
COPY . .

RUN apt update \
    # Source ros
    && . /ros_entrypoint.sh \
    # Build the workspace
    && colcon build \
    # Begin Bundling
    && colcon bundle

# End of builder image
FROM ros2cuisine/bundler as bundle

# Have a look at https://gitlab.com/ros2cuisine/bundler to learn how to bundle
```
