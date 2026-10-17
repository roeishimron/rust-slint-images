# Project layer: pinned Rust + Android targets + Slint desktop deps + the dev tools every gate needs.
# The agent CLI is NOT installed here; each project's devcontainer.json adds it.
ARG REGISTRY=ghcr.io/roeishimron
ARG ANDROID_API=35
FROM ${REGISTRY}/android-base:${ANDROID_API}

ARG RUST_VERSION=1.99.1
ARG CARGO_APK=0.10.0
ARG CARGO_MUTANTS=27.1.0
ARG CARGO_NEXTEST=0.9.148
ARG CARGO_DENY=0.20.2
ARG SCCACHE=0.18.0
ARG SLINT_LSP=1.18.1

LABEL org.opencontainers.image.source=https://github.com/roeishimron/rust-slint-images

USER root
# clang/lld/llvm: Skia renderer. The rest: Slint's winit backend (X11/Wayland, GL),
# xvfb for a visible desktop run without a display, and the usual agent tools.
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential pkg-config clang lld llvm \
        libfontconfig1-dev libfreetype-dev libxkbcommon-dev libxkbcommon-x11-0 \
        libwayland-dev libx11-dev libx11-xcb1 libxcursor1 libxi6 libxrandr2 \
        libgl1 libegl1 libgl1-mesa-dri \
        xvfb xauth ripgrep jq make git \
    && rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:${PATH}
RUN mkdir -p ${RUSTUP_HOME} ${CARGO_HOME} && chown 1000:1000 ${RUSTUP_HOME} ${CARGO_HOME}

USER 1000
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal \
        --default-toolchain ${RUST_VERSION} \
        --component rustfmt,clippy \
        --target aarch64-linux-android,x86_64-linux-android

RUN cargo install --locked \
        cargo-mutants@${CARGO_MUTANTS} \
        cargo-nextest@${CARGO_NEXTEST} \
        cargo-deny@${CARGO_DENY} \
        sccache@${SCCACHE} \
        slint-lsp@${SLINT_LSP} \
        cargo-apk@${CARGO_APK} \
    && rm -rf ${CARGO_HOME}/registry ${CARGO_HOME}/git

# sccache for every build; projects mount a volume at /home/vscode/.cache/sccache.
ENV RUSTC_WRAPPER=sccache
