
ARG ROS_DISTRO=eloquent
ARG GITLAB_USERNAME=ros2cuisine
ARG TARGET_ARCH=amd64
ARG FUNCTION_NAME=builder
ARG VCS_REF

ARG FLAVOR=alpine
ARG FLAVOR_VERSION=3.10.3

FROM ${TARGET_ARCH}/${FLAVOUR}:${FLAVOUR_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apk update \
    # Install barebones
    apk add \
        bash \
        python3-dev \
    # bash for debug
    && rm -rf /var/lib/apt/lists/* \
    # Create Working directory for builds
    && mkdir -p /cuisine/workspaces

# Choose the directory for builds
WORKDIR /cuisine/workspaces

# Finishing the image
ENTRYPOINT ["/opt/ros/$ROS_DISTRO/ros_entrypoint.sh"]
CMD ["bash"]

LABEL org.label-schema.name="ros2cuisine/builder:eloquent-alpine-x86_64" \
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
