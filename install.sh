#!/bin/bash
# localsend-cli installer — works on Linux and macOS
set -e

REPO="Chordlini/localsend-cli"
BINARY="localsend-cli"

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*)  PLATFORM="linux" ;;
  Darwin*) PLATFORM="macos" ;;
  *)       echo "Unsupported OS: $OS" && exit 1 ;;
esac

echo "Detected: $PLATFORM"

# Determine install directory
if [ "$PLATFORM" = "macos" ]; then
  INSTALL_DIR="/usr/local/bin"
else
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
fi

# Check dependencies
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required."
  if [ "$PLATFORM" = "macos" ]; then
    echo "Install with: brew install python3"
  else
    echo "Install with: sudo apt install python3  OR  sudo pacman -S python"
  fi
  exit 1
fi

if ! command -v openssl &>/dev/null; then
  echo "Error: openssl is required."
  if [ "$PLATFORM" = "macos" ]; then
    echo "Install with: brew install openssl"
  else
    echo "Install with: sudo apt install openssl  OR  sudo pacman -S openssl"
  fi
  exit 1
fi

# Download
echo "Downloading localsend-cli..."
curl -fsSL "https://raw.githubusercontent.com/$REPO/master/$BINARY" -o "$INSTALL_DIR/$BINARY"
chmod +x "$INSTALL_DIR/$BINARY"

# Verify
if command -v localsend-cli &>/dev/null; then
  echo ""
  echo "Installed successfully!"
  echo "  Location: $INSTALL_DIR/$BINARY"
  echo ""
  echo "Try it:"
  echo "  localsend-cli discover -t 2"
else
  echo ""
  echo "Installed to: $INSTALL_DIR/$BINARY"
  echo ""
  if [ "$PLATFORM" = "linux" ]; then
    echo "Make sure ~/.local/bin is in your PATH:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
fi
