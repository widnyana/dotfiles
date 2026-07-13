_:
{
  parts.homeConfigurations = {
    "wid@joy" = {
      system = "aarch64-darwin";
      stateVersion = "23.05";

      modules = [ ./wid/home.nix ];
    };
  };
}