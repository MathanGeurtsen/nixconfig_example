# Default recipe lists recipes
default:
    @just --list

# Update flake inputs
update:
    nix flake update

# Build and switch to the home-manager configuration
switch:
    nix run home-manager/master -- switch --flake .\#$(whoami)@$(hostname) -b backup

# Check the flake for errors
check:
    nix flake check

# Format Nix files (requires nixpkgs-fmt to be added)
fmt:
    nixpkgs-fmt .


# check if the repo is dirty (fails if any non-commited changes are pushed)
clean-repo:
    git diff-index --quiet HEAD -- || exit 1

# Run garbage collection
gc:
    home-manager expire-generations "-1 days"
    nix-collect-garbage -d

# update inputs, run checks, if successful build and switch to new configuration
upgrade: update check fmt clean-repo switch gc
