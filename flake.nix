{
  description = "Gitpod";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
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
    };
}
