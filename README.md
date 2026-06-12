# minimal nix home manager setup

This repository is a starting point for creating a nix home manager configuration on linux. [Home manager](https://nix-community.github.io/home-manager/) is a package and configuration manager based on nix, which allows for reproducible installation of packages and configurations.

This repository serves as an empty canvas with minimal structure and a couple of examples of how it could be extended. 

The installation creates an (almost) empty `~/.bashrc`, and installs the task runner `just` and `hello`, an example nixpkgs package. Your already installed packages will still be available. Installation will backup an already existing `~/.bashrc`.

## setup instructions 

The following command will clone the repository, install [lix](https://lix.systems/) (community fork of nix), then build and install the example configuration in `flake.nix`. Refresh the shell afterwards (e.g. by running `bash` in the current shell).

This command will also work inside of a docker container.

```bash
git clone https://github.com/mathangeurtsen/nixconfig_example && cd nixconfig_example && bash install-minimal.sh
```


## dependencies and assumptions

The install scripts expects a bash shell, and a user with sudo rights (not root itself, the home directory is different). x86_64 architecture is assumed.

You'll need the following packages prior to installation:

 - git
 - xz (for unzipping)
 - curl
 - sudo


## Further notes 

This repository is originally based on https://github.com/juspay/nixos-unified-template, which is a great starting template for using nix and home manager, it's more batteries included.

If you'd like you can configure *much more* then I'm showing here in home manager. For example, there's extensions like [nixvim](https://nix-community.github.io/nixvim/) which can also manage neovim packages. 

**minimalism**

Over time, I've found myself rewriting my config to be more and more minimal. I've moved most of my configurations back into dotfiles, because I don't want to be dependent on both the documentation of the tool itself and the documentation of the nix configuration manager. I want my configuration to be fire and forget: I program in once what I want my tools to behave like, and then forget it ever had different defaults, or even how to set the configuration. I want my computing environment to be boring and stable, and this minimal structure has allowed me to do a lot of firing and forgetting.

**why not share my actual configuration?**

I've decided against sharing my actual configuration for security reasons. My personal repository details what computers I have, which packages are installed, how I've configured them, and even which specific versions of packages are installed. Sharing that to the open internet seems like asking for trouble.

