#!/usr/bin/env bash
# Minimal Home Manager installer
# Installs Nix + switches to config matching $(whoami)@$(hostname)

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

NIXCONFIG_DIR="${NIXCONFIG_DIR:-.}"

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

is_docker() {
  [ -f /.dockerenv ] && return 0
  grep -qi docker /proc/1/cgroup 2>/dev/null && return 0
  return 1
}

install_nix_if_needed() {
  command -v nix &>/dev/null && { log_info "Nix already installed"; return 0; }

  log_info "Installing Nix..."
  command -v curl &>/dev/null || { log_error "curl required"; return 1; }

  local init_arg=""
  is_docker && init_arg="--init none"

  curl -sSf -L https://install.lix.systems/lix | sh -s -- install linux $init_arg || return 1
  export PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"
}


switch_to_config() {
  log_info "Switching to home-manager config..."

  cd "$NIXCONFIG_DIR"
  export PATH="/nix/var/nix/profiles/default/bin:${PATH}"
  export HOME="${HOME:-/root}"
  export USER="$(whoami)"

  local user="$USER"
  local host=$(hostname)
  local flake_key="$user@$host"
  local home_dir="$HOME"

  # Inject actual user/host into flake.nix
  sed -i.bak \
    -e "s/\"<user>@<hostname>\"/\"$flake_key\"/" \
    -e "s/home.username = \"<user>\"/home.username = \"$user\"/" \
    -e "s|home.homeDirectory = \"/home/<user>\"|home.homeDirectory = \"$home_dir\"|" \
    flake.nix

  nix run home-manager/master -- switch \
    --flake ".#$flake_key" \
    -b backup || { log_error "switch failed"; return 1; }
}

install_nix_if_needed || { log_error "Nix install failed"; exit 1; }
switch_to_config || { log_error "switch failed"; exit 1; }
log_info "Done"
