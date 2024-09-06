{
  description = "Gitpod";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let 
      architecture = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${architecture};
    in
    {
      devShells.${architecture}.default = pkgs.mkShell {
        packages = with pkgs;[
          neovim
          tmux
          fd
          lazygit
          lazydocker
        ];
        shellHook = ''
          tmux new-session -s fish
          '';
      };
      homeConfigurations.gitpod = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
    };
}
