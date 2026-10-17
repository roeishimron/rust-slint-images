# rust-slint-images

Devcontainer/CI images for Rust + Slint projects that ship natively on desktop and Android.

| Image | Tag | FROM | Holds |
|---|---|---|---|
| `roeish/android-base` | `<api>` (e.g. `35`) | `mcr.microsoft.com/devcontainers/base:trixie` | JDK 21, Google's Android CLI (`android`), pinned platform-tools, build-tools, platform, NDK. Telemetry off via `~/.androidrc`. |
| `roeish/rust-slint` | `<rust>-api<api>` (e.g. `1.99.1-api35`) | `roeish/android-base:<api>` | Rust + Android targets, clang/lld, Slint desktop libs, xvfb, cargo-apk, cargo-mutants, cargo-nextest, cargo-deny, sccache, slint-lsp. |

No agent CLI is baked in: each project's `devcontainer.json` installs its agent.

```sh
make build VERSION=1.99.1            # both layers, ANDROID_API=35 by default
make all   VERSION=1.99.1            # build + push
```

Pins live as `ARG` defaults at the top of each Dockerfile. The Android CLI itself only has a `latest`
channel, so reproducibility comes from the pinned SDK packages it installs.

APKs are built with cargo-apk (Slint's documented tool), which uses the image's SDK and NDK as they are.
The SDK platform is the apps' target SDK and must not exceed what the NDK knows (r28: API 35); raise both
together.

Verified 2026-10-17 (image rebuild pending): L1/L2, L3 desktop, mutation testing, release guard,
cargo-deny; cargo-apk APKs (target 35) install and run on an API-36 emulator, with Slint's MCP server and
the devtools server reachable through `adb forward`.

Not baked in on purpose: the emulator's system image (GBs, needs KVM). Projects install it on first use
into a cache volume (`make emulator`). The emulator binary itself is baked in.
