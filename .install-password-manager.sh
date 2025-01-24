#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type rbw >/dev/null 2>&1 && exit
INSTALL_PATH="$HOME/.local/bin"

case "$(uname -s)" in
  Linux)
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
    rm -rf rbw.tar.gz /tmp/rbw/-*
    ;;
  *)
    echo "unsupported OS"
    exit 1
    ;;
esac
