{ config, pkgs, ... }:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "35" ];
    buildToolsVersions = [ "35.0.0" ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis" ];
    abiVersions = [ "arm64-v8a" ];
    includeNDK = false;
    includeSources = false;
    extraLicenses = [
      "android-sdk-license"
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
in
{
  # Set ANDROID_HOME so Gradle can find the SDK
  environment.variables.ANDROID_HOME = "${androidSdk.androidsdk}/libexec/android-sdk";

  # Add Android SDK tools to PATH
  environment.systemPath = [
    "${androidSdk.androidsdk}/libexec/android-sdk/emulator"
    "${androidSdk.androidsdk}/libexec/android-sdk/platform-tools"
    "${androidSdk.androidsdk}/libexec/android-sdk/cmdline-tools/19.0/bin"
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    _1password-cli
    aichat
    android-tools
    awscli2
    bash-language-server
    bat
    carapace
    coreutils-prefixed
    curl
    delta
    difftastic
    dotnet-sdk
    eza
    fd
    fzf
    git
    glow
    go
    gopls
    gh
    google-cloud-sdk
    gradle
    grpcurl
    jdk21
    jujutsu
    jjui
    just
    k9s
    kotlin
    kanata
    kind
    kubectl
    kubectx
    kustomize
    lazygit
    lazyjj
    lua
    lua-language-server
    luarocks
    markdownlint-cli2
    markdown-oxide
    marksman
    mas
    maven
    mdbook
    mdbook-toc
    mdbook-mermaid
    mdbook-admonish
    mdbook-pdf-outline
    mdbook-pagetoc
    mdbook-epub
    mdcat
    fastfetch
    neovide
    neovim
    nushell
    obsidian
    pandoc
    pnpm
    postman
    presenterm
    protobuf
    python313
    python313Packages.pip
    pyright
    ripgrep
    ripgrep-all
    rustup
    starship
    telegram-desktop
    tilt
    typescript-language-server
    typst
    typstyle
    uv
    vivid
    yaml-language-server
    yazi
    yt-dlp
    zoxide
  ];
}
