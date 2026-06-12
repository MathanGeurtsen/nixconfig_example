{
  description = "Minimal Home Manager configuration";

  inputs = {
    # we're using unstable: more frequent updates, possible breakage
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      baseModules = [
        ./home_modules/home.nix
        ./home_modules/link_dotfiles.nix
        ./home_modules/packages_shared.nix
      ];
    in
    {
      homeConfigurations = {
        # This is the active profile after install
        # You'll note the install script overwrote username and hostname , but it's not yet committed
        "<user>@<hostname>" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = baseModules ++ [
            {
              home.username = "<user>";
              # if your home directory isn't in home, you'll need to change it here
              home.homeDirectory = "/home/<user>";
              home.packages = with pkgs; [
                # example if you want to add a package to this profile only
                # search packages on https://search.nixos.org/
                hello
              ];
            }
          ];
        };
        "<otheruser>@<otherhostname>" = home-manager.lib.homeManagerConfiguration {
          # Another profile. You could specify a different setup for a work account for example.
          inherit pkgs;

          modules = baseModules ++ [
            {
              home.username = "<otheruser>";
              home.homeDirectory = "/home/<otheruser>";
            }
          ];
        };
      };

      # This allows the command `nix run` to switch to the config
      # The other commands are in just, but if something goes wrong, this is an escape hatch
      apps.${system} = {
        default = {
          type = "app";
          meta = {
            description = "Switch to the defined home manager configuration.";
          };

          program = toString (pkgs.writeShellScript "home-manager-switch" ''
            ${home-manager.packages.${system}.home-manager}/bin/home-manager \
              switch --flake .#$(whoami)@$(hostname)
          '');
        };
      };
    };
}
