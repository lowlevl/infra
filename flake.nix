{
  description = "Repository to store and increment on my IaC, using NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    ...
  } @ inputs: {
    formatter = flake-utils.lib.eachDefaultSystemPassThrough (system: {${system} = nixpkgs.legacyPackages.${system}.alejandra;});

    overlays = {
      "old-packages" = final: prev: {old = import inputs.nixpkgs-old {system = final.system;};};
      "unstable-packages" = final: prev: {unstable = import inputs.nixpkgs-unstable {system = final.system;};};
    };

    nixosModules = {
      env = ./mods/env.nix;
      ssh = ./mods/ssh.nix;
      users = ./mods/users.nix;
      locale = ./mods/locale.nix;
      decrypt = ./mods/decrypt.nix;
      git-annex = ./mods/git-annex;
    };

    homeModules = {
      X = ./mods/hm/X;
      hm = ./mods/hm/hm.nix;
      pam = ./mods/hm/pam.nix;
      shell = ./mods/hm/shell.nix;
      neovim = import ./mods/hm/neovim.nix {inherit (inputs) nixvim;};
      nixgl = import ./mods/hm/nixgl.nix {inherit (inputs) nixgl;};
    };

    nixosConfigurations."nyx" = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit (inputs) self nixpkgs nixpkgs-unstable sops-nix nixos-hardware;
      };

      system = "aarch64-linux";
      modules = [./confs/nyx];
    };

    homeConfigurations."bee" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit (inputs) self;
        username = "bee";
      };

      pkgs = import nixpkgs {system = "x86_64-linux";};
      modules = [./homes/bee.nix];
    };
  };
}
