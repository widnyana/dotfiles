_:

{
  # nix-darwin configurations
  parts.darwinConfigurations.mac = {
    system = "aarch64-darwin";
    stateVersion = 4;
    modules = [ ./mac/configuration.nix ];
  };
}
