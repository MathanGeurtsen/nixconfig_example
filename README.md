# Minimal nix home manager setup

This repository is a starting point for creating a nix home manager configuration on linux. [Home manager](https://nix-community.github.io/home-manager/) is a package and configuration manager based on nix, which allows for a declarative installation of packages and configurations.

This repository serves as an empty canvas with minimal structure and a couple of examples of how it could be extended. 

## Setup instructions 

The following commands will install [lix](https://lix.systems/) (community fork of nix), then build and install the example configuration in `flake.nix`. Do read the [dependencies](#dependencies) section if you encounter issues. These commands also works inside a docker container, and your already installed packages will still be available.

```bash
git clone https://github.com/mathangeurtsen/nixconfig_example ~/nixconfig_example
cd ~/nixconfig_example
bash install-minimal.sh
```

That's it! Refresh the shell afterwards (e.g. by running `bash` in the current shell). You can now run `hello`, to see a "Hello, world!" from the nix managed package. Your `~/.bashrc` is now managed by home manager. You can now add more packages, or add more configuration files. There are some minimal comments in the repository denoting the structure. Start by reading [flake.nix](./flake.nix).

## Dependencies

The install script works for a user with sudo rights on linux using a bash shell. x86_64 architecture is assumed.

You'll need the following packages prior to installation:

 - git
 - xz (for unzipping)
 - curl
 - sudo

## Further notes 

**common operation and footguns**

Here are the most important commands (see the justfile for more):

 - `just upgrade`: update package source list & activate latest changes after safety checks like if everything is committed (boring & safe)
 - `just switch`: implement latest configuration changes (faster, allows dirty repo)

If you add files to this repo you must add the new file to git at least once (`git add <file>`) before home manager can access it. 

Note that the files managed by this configuration will be symlinks, and they will be write protected. This does force you to modify this repository instead of the files directly. For example, if you also manage `~/.gitconfig` with home manager then commands like `git config ...` **will fail** unless you remove these files first. You might also notice that some software will try to sneakily add something to your config files- this will also fail. This might be a drawback, but it's also a blessing: your configuration is now wholly owned by you, and there is a single source of truth, and single editing mechanism.

**Inspiration of the repo and inspiration for you**

This repository is originally based on https://github.com/juspay/nixos-unified-template, which is a great starting template for using nix and home manager. It's much more batteries included.

If you'd like, home manager can configure *much more* then I'm showing here. For example, there's extensions like [nixvim](https://nix-community.github.io/nixvim/) which can also manage neovim packages. If you use the operating system [nixOS](https://nixos.org/), you can configure pretty much anything- but you also *must* configure everything through nix. It's a trade-off.

**Can you share your actual configuration?**

I've decided against sharing my actual configuration. My personal repository details which packages are installed, their versions, and how I've configured them. Sharing that to the open internet seems like asking for trouble.

**Concerning minimalism**

Over time, I've found myself rewriting my config to be more and more minimal. I've also moved most of my configurations back into symlinked dotfiles over using things like nixvim. This way I'm dependent on only *one* configuration language for that tool. 

I want my configuration to be fire and forget: I configure once how I want my tools to behave, then forget it ever had different defaults or even how to set the configuration. This minimal structure has allowed me to do a lot of firing and forgetting.

I also want my computing environment to be comfortable, boring and stable. Using a minimal home manager repo for declarative configuration and package management on top of ubuntu or fedora means I can use home manager where it makes sense, but can also use "normal" linux if that serves me better. This is a pretty boring setup- which is the point. I can do all kinds of cool shit on my computer- but the basics *should be boring*.

