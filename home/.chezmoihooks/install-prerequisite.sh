#!/usr/bin/env bash

set -eu

OS_NAME=$(grep "^ID=" /etc/os-release | cut -d= -f2)

INSTALL_PATH="/usr/bin"

UBUNTU_DEBIAN_PACKAGES=(
  curl
  git
  gpg
  pinentry-tty
)

ARCH_PACKAGES=(
  git
  rbw
  yay-bin
)

missing_packages=()

install_yay() {
  # Install yay if not already installed
  if ! command -v yay &>/dev/null; then

    log_task "yay could not be found, installing..."
    sudo pacman -S --noconfirm base-devel
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin || exit
    makepkg -si --noconfirm
    cd .. || exit
    rm -rf yay-bin
  fi
}

check_install_rbw_bin() {
  if ! command -v rbw &>/dev/null; then
    log_task "rbw could not be found, installing..."
    VERSION=$(curl -s https://api.github.com/repos/doy/rbw/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    curl -Lo rbw.tar.gz "https://github.com/doy/rbw/releases/download/${VERSION}/rbw_${VERSION}_linux_amd64.tar.gz"
    # Extract the archive
    mkdir -p /tmp/rbw-"${VERSION}"
    tar xf rbw.tar.gz --directory=/tmp/rbw-"${VERSION}"/

    # Install the binary
    if uname -a | grep -q "arch"; then
      INSTALL_PATH="/usr/bin"
    fi
    sudo mv /tmp/rbw-*/rbw "${INSTALL_PATH}"/
    sudo mv /tmp/rbw-*/rbw-agent "${INSTALL_PATH}"/

    # Cleanup
    rm -rf rbw.tar.gz /tmp/rbw-*
  fi
}

check_apt_package() {
  for package in "${UBUNTU_DEBIAN_PACKAGES[@]}"; do
    if ! command -v "${package}" >/dev/null; then
      missing_packages+=("${package}")
    fi
  done
}

check_pacman_package() {
  local output
  set +e
  output=$(sudo pacman -Q "${ARCH_PACKAGES[@]}" 2>&1)
  set -e
  while IFS= read -r line; do
    if [[ "$line" == *"error: package"* ]]; then
      # Extract package name from error message
      local pkg_name
      pkg_name=$(echo "$line" | sed -e "s/error: package '\(.*\)' was not found/\1/")
      missing_packages+=("$pkg_name")
    fi
  done <<<"$output"
  # missing_packages=$(echo "$output" | grep "error: package" | sed -e "s/error: package '\(.*\)' was not found/\1/" | tr '\n' ' ' | sed 's/ $//')
}

case "$OS_NAME" in
  "ubuntu" | "debian")
    check_apt_package
    if [[ ${#missing_packages[@]} -eq 0 ]]; then
      exit 0
    fi

    # shellcheck source=../.chezmoitemplates/utils
    source "${CHEZMOI_SOURCE_DIR?}/.chezmoitemplates/utils"

    log_info "Os detected: ${OS_NAME}"
    log_task "Installing missing packages: ${missing_packages[*]}"
    DEBIAN_FRONTEND=noninteractive sudo apt update && sudo apt install "${missing_packages[@]}" --yes
    check_install_rbw_bin
    ;;
  "arch")
    install_yay
    check_pacman_package
    if [[ ${#missing_packages[@]} -eq 0 ]]; then
      exit 0
    fi

    # shellcheck source=../.chezmoitemplates/utils
    source "${CHEZMOI_SOURCE_DIR?}/.chezmoitemplates/utils"

    log_info "Os detected: ${OS_NAME}"
    log_task "Installing missing packages: ${missing_packages[*]}"

    sudo pacman -Syu --noconfirm "${missing_packages[@]}"
    ;;
  *)
    log_error "unsupported OS"
    exit 1
    ;;
esac
