{pkgs,...}:
{
  home.username = "gitpod";
  home.homeDirectory = "/home/gitpod";
  home.stateVersion = "18.09";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [ 
    neovim
    tmux
    fd
    lazygit
    lazydocker
  ];
  
  programs.fish = {
    enable = true;
    shellAbbrs = {
      t = "tmux";
      tks = "tmux kill-session";
      tls = "tmux list-sessions";
      tlc = "tmux list-clients";
      tns = "tmux new -s";
      dc = "docker-compose";
      dcp = "docker-compose --profile";
      dcf = "docker-compose --file";
      lzd = "lazydocker";
      lzg = "lazygit";
      lg = "lazygit";
      v = "nvim";
    };
    interactiveShellInit= #fish
      ''
        set fish_greeting;
        fish_vi_key_bindings
        source ("starship" init fish --print-full-init | psub)
      '';
  };

  programs.starship = {
    enable = true;
  };
}
