# Base layer: devcontainer user (vscode, UID 1000) + JDK + Google's Android CLI + a pinned Android SDK.
# Every package below is pinned; bump them deliberately and retag.
FROM mcr.microsoft.com/devcontainers/base:trixie

# The SDK platform = the apps' target SDK. Keep it <= the NDK's NDK_MAX_PLATFORM_LEVEL (r28: 35):
# cargo-apk ignores platforms the NDK doesn't know.
ARG ANDROID_API=35
ARG ANDROID_PLATFORM_TOOLS=37.0.1
ARG ANDROID_BUILD_TOOLS=36.0.0
ARG ANDROID_NDK=28.2.13676358
ARG ANDROID_EMULATOR=37.2.12

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME} \
    ANDROID_NDK_ROOT=${ANDROID_HOME}/ndk/${ANDROID_NDK} \
    ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK} \
    PATH=${PATH}:/opt/android-sdk/platform-tools:/opt/android-sdk/build-tools/${ANDROID_BUILD_TOOLS}:/opt/android-sdk/emulator

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-21-jdk-headless curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Android CLI (one line; only a `latest` channel exists, so the SDK packages below carry the pins).
RUN curl -fsSL https://dl.google.com/android/cli/latest/linux_x86_64/install_root.sh | bash

# SDK packages. `android sdk install` accepts the licences non-interactively.
RUN mkdir -p ${ANDROID_HOME} \
    && android --no-metrics --sdk=${ANDROID_HOME} sdk install \
        platform-tools@${ANDROID_PLATFORM_TOOLS} \
        build-tools/${ANDROID_BUILD_TOOLS} \
        platforms/android-${ANDROID_API} \
        ndk/${ANDROID_NDK} \
        emulator@${ANDROID_EMULATOR} \
    && chown -R 1000:1000 ${ANDROID_HOME}

# System images (GBs) and AVDs live in volumes mounted here; `make emulator` fills them on first use.
# (The emulator binary itself is baked in above: a package can't be installed onto a mount point.)
ENV ANDROID_AVD_HOME=/home/vscode/.android/avd
RUN mkdir -p ${ANDROID_HOME}/system-images ${ANDROID_AVD_HOME} \
    && chown 1000:1000 ${ANDROID_HOME}/system-images /home/vscode/.android ${ANDROID_AVD_HOME}

# Default flags for every `android` call: no telemetry, fixed SDK path.
RUN printf -- '--no-metrics\n--sdk=%s\n' "${ANDROID_HOME}" | tee /root/.androidrc > /home/vscode/.androidrc \
    && chown 1000:1000 /home/vscode/.androidrc

USER 1000
# Unpack the CLI's embedded runtime once for the vscode user, so first use in a container is fast.
RUN android -V
