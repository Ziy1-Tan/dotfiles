{
  description = "Ziy1-Tan's home environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/c59305bab2065cfecc4944690d9eedbb56f3a9fa";

    home-manager = {
      url = "github:nix-community/home-manager/acd21c5a3420a9d5fd0ed06299b10828267ef9ba";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, ... }:
    let
      currentUser = builtins.getEnv "USER";
      currentHome = builtins.getEnv "HOME";
      resolvedUser =
        if currentUser != "" then currentUser else builtins.baseNameOf currentHome;

      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkHome = system: username: homeDirectory:
        let
          pkgs = mkPkgs system;
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };

      homeManagerPackage = system:
        let
          pkgs = mkPkgs system;
        in
          if builtins.hasAttr system home-manager.packages
          then home-manager.packages.${system}.home-manager
          else pkgs.home-manager;
    in {
      apps.${builtins.currentSystem}.home-manager = {
        type = "app";
        program = "${homeManagerPackage builtins.currentSystem}/bin/home-manager";
      };

      homeConfigurations = {
        # The active user and home directory come from the environment at
        # activation time, matching the original single-user workflow.
        default =
          assert currentHome != "";
          assert resolvedUser != "";
          mkHome builtins.currentSystem resolvedUser currentHome;
      };

      checks.${builtins.currentSystem}.home-manager =
        (mkHome builtins.currentSystem resolvedUser currentHome).activationPackage;
    };
}
