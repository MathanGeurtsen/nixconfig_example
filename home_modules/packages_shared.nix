{ pkgs, ... }:
{
  # shared packages can be defined here
  home.packages = with pkgs; [
    just
  ];
  home.sessionVariables = {
    # example env var definition
    # EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  programs = {
    # example home manager based configuration of direnv
    # direnv = {
    #   enable = true;
    #   nix-direnv = {
    #     enable = true;
    #   };
    #   config.global = {
    #     # Make direnv messages less verbose
    #     hide_env_diff = true;
    #   };
    # };
  };
}
