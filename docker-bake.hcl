# Both images. Local: `docker buildx bake`. Publish: `docker buildx bake --push` (CI does it on main).
# Versions live here; override one with e.g. `RUST_VERSION=1.100.0 docker buildx bake`.
# ANDROID_API is the apps' target SDK: keep it <= the NDK's max platform level (r28: 35).
variable "REGISTRY" { default = "ghcr.io/roeishimron" }
variable "ANDROID_API" { default = "35" }
variable "RUST_VERSION" { default = "1.99.1" }

group "default" { targets = ["android-base", "rust-slint"] }

target "android-base" {
  context = "android-base"
  args    = { ANDROID_API = ANDROID_API }
  tags    = ["${REGISTRY}/android-base:${ANDROID_API}"]
}

target "rust-slint" {
  context  = "rust-slint"
  contexts = { base = "target:android-base" } # the image built above, never a stale pull
  args     = { RUST_VERSION = RUST_VERSION }
  tags     = ["${REGISTRY}/rust-slint:${RUST_VERSION}-api${ANDROID_API}"]
}
