{ ... }:
{
  # Wire config_files/* to home.file and xdg.configFile
  
  home.file = {
    ".bashrc" = {
      source = ../home_modules/config_files/bashrc.sh;
    };
  };
}
