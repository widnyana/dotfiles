{
  description = "Widnyana's Nix Configurations";

  outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; } {
    systems = [ "aarch-darwin" "x86_64-linux" ];
    imports = [
      ./modules/parts
    ];
  };

  inputs =
    {

      # -- Nix lang & nixpkgs help
      nix.url = "github:nixos/nix";
      nix-index-database.url = "github:Mic92/nix-index-database";
      nixpkgs-fmt.url = "github:nix-community/nixpkgs-fmt";
      parts.url = "github:hercules-ci/flake-parts";
      statix.url = "github:nerdypepper/statix";

      # -- nixpkgs
      master.url = "github:NixOS/nixpkgs/master";
      stable.url = "github:NixOS/nixpkgs/release-23.05";
      unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      nur.url = "github:nix-community/NUR";

      # Default Nixpkgs for packages and modules
      nixpkgs.follows = "master";

      # -- platform support
      darwin.url = "github:lnl7/nix-darwin";
      vscode-server.url = "github:nix-community/nixos-vscode-server";

      # -- tooling
      # colorscheme
      nix-colors.url = "github:Misterio77/nix-colors";

      # Minimize duplicate instances of inputs
      nix.inputs.nixpkgs.follows = "nixpkgs";
      nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
      statix.inputs.nixpkgs.follows = "nixpkgs";

    };

}
