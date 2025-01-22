#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type rbw >/dev/null 2>&1 && exit

case "$(uname -s)" in
  Linux)
    ARCH_NAME
    VERSION=$(curl -s https://api.github.com/repos/doy/rbw/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    curl -Lo rbw.tar.gz "https://github.com/doy/rbw/releases/download/${VERSION}/rbw_${VERSION}_linux_amd64.tar.gz"
    # Extract the archive
    mkdir -p /tmp/rbw-"${VERSION}"
    tar xf rbw.tar.gz --directory=/tmp/rbw-"${VERSION}"/

    # Install the binary
    sudo mv /tmp/rbw-*/rbw /usr/bin/
    sudo mv /tmp/rbw-*/rbw-agent /usr/bin/

    # Cleanup
    rm -rf rbw.tar.gz /tmp/rbw/-*
    ;;
  *)
    echo "unsupported OS"
    exit 1
    ;;
esac
