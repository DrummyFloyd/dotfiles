#!/usr/bin/env bash

# read-source-state.pre hook: make sure what templates need (git, rbw...) is
# available before chezmoi renders anything. It runs on every chezmoi command,
# so each check must be cheap when there is nothing to do.

# shellcheck source=../.chezmoitemplates/utils
source "${CHEZMOI_SOURCE_DIR?}/.chezmoitemplates/utils"

# shellcheck disable=SC1091
OS_ID=$(. /etc/os-release && echo "${ID}")

UBUNTU_PACKAGES=(
  curl
  git
  gpg
  pinentry-tty
)

ARCH_PACKAGES=(
  git
  rbw
)

WORK_DIR=""
trap 'rm -rf "${WORK_DIR}"' EXIT

install_missing_apt_packages() {
  local missing=()
  for pkg in "${UBUNTU_PACKAGES[@]}"; do
    if ! dpkg-query -W -f='${db:Status-Abbrev}' "${pkg}" 2>/dev/null | grep -q '^ii'; then
      missing+=("${pkg}")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    log_task "Installing missing packages: ${missing[*]}"
    sudo apt-get update
    # INFO: through env, sudo resets the caller environment
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}"
  fi
}

install_missing_pacman_packages() {
  local missing
  # INFO: pacman -T prints unsatisfied targets only, exits 127 when some are missing
  mapfile -t missing < <(pacman -T "${ARCH_PACKAGES[@]}" || true)

  if [[ ${#missing[@]} -gt 0 ]]; then
    log_task "Installing missing packages: ${missing[*]}"
    sudo pacman -Syu --needed "${missing[@]}"
  fi
}

install_yay() {
  if command -v yay &>/dev/null; then
    return
  fi

  log_task "yay could not be found, installing..."
  sudo pacman -S --needed --noconfirm base-devel git
  WORK_DIR=$(mktemp -d)
  git clone --depth 1 https://aur.archlinux.org/yay-bin.git "${WORK_DIR}/yay-bin"
  (cd "${WORK_DIR}/yay-bin" && makepkg -si --noconfirm)
}

# INFO: bootstrap copy in /usr/local/bin (in default PATH, not owned by dpkg),
# replaced by mise (github:doy/rbw) then removed by
# run_after_99-prune-non-mise-rbw-on-ubuntu
install_rbw_bootstrap() {
  if command -v rbw &>/dev/null; then
    return
  fi

  if [[ "$(uname -m)" != "x86_64" ]]; then
    error "rbw: upstream only ships linux x86_64 binaries, install it manually"
  fi

  local tag archive
  # INFO: latest tag from the release redirect, no GitHub API rate limit
  tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/doy/rbw/releases/latest)
  tag=${tag##*/}
  archive="rbw_${tag}_linux_amd64.tar.gz"

  log_task "rbw could not be found, installing ${tag} to /usr/local/bin..."
  WORK_DIR=$(mktemp -d)
  curl -fsSL -o "${WORK_DIR}/${archive}" "https://github.com/doy/rbw/releases/download/${tag}/${archive}"
  tar -xzf "${WORK_DIR}/${archive}" -C "${WORK_DIR}"
  sudo install -m 0755 "${WORK_DIR}/rbw" "${WORK_DIR}/rbw-agent" /usr/local/bin/
}

# INFO: templates call rbw as soon as they are rendered, configure it here so
# the bootstrap does not depend on ~/.config/rbw/config.json being applied
# before them. Args come from the chezmoi config (bitwarden email, server).
# Each key is checked on its own so a partial configuration gets fixed.
rbw_config_ensure() {
  local key="$1" value="$2"
  if ! grep -qF "\"${key}\": \"${value}\"" <<<"${rbw_config}"; then
    log_task "Setting rbw ${key}"
    rbw config set "${key}" "${value}"
  fi
}

configure_rbw() {
  local email="${1:-}" server="${2:-}" rbw_config
  if [[ -z "${email}" ]]; then
    return
  fi

  # INFO: fails on a fresh machine as long as no config file exists
  rbw_config=$(rbw config show 2>/dev/null || true)
  rbw_config_ensure email "${email}"
  if [[ -n "${server}" ]]; then
    rbw_config_ensure base_url "${server}"
  fi
  rbw_config_ensure pinentry pinentry-tty
}

case "${OS_ID}" in
  ubuntu | debian)
    install_missing_apt_packages
    install_rbw_bootstrap
    configure_rbw "$@"
    ;;
  arch)
    install_missing_pacman_packages
    install_yay
    configure_rbw "$@"
    ;;
  *)
    error "Unsupported OS: ${OS_ID}"
    ;;
esac
