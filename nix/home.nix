{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I_use_󱄅__BTW󰇳";
    };
    initExtra = ''
      _format_dir() {
        # Substitui o caminho home por ~ e trata casos especiais
        if [[ "$PWD" == "$HOME" ]]; then
           echo -n "~''${USER##*/}"
        elif [[ "$PWD" == "$HOME/"* ]]; then
           current_dir="~''${PWD#$HOME}"
           dir_depth=$(tr -cd '/' <<< "$current_dir" | wc -c)

           if (( dir_depth <= 2 )); then
              echo -n "$current_dir"
           else
              echo -n "~/.../''${current_dir##*/*/}"
           fi
       else
          echo -n "$PWD"
       fi
      }

      get_git_info() {
        git_dir=$(git rev-parse --git-dir 2>/dev/null)
        [ -n "$git_dir" ] && {
          branch=$(git branch --show-current 2>/dev/null)
                [ -n "$branch" ] && echo -e " \001\033[1;38;2;207;62;139m\002( \001\033[1;38;2;207;62;139m\002$branch)\001\033[0m\002"
        }
      }



      export PS1="\n\n\[$(tput bold)\]\[\033[38;2;72;205;232m\]\$(_format_dir)\[$(tput sgr0)\]\$(get_git_info)\n\[$(tput bold)\]\[\033[38;2;66;173;103m\]❯\[$(tput sgr0)\] "



    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
set -g mouse on

set -g window-status-format "#[bg=default,fg=#141414]\uE0B6#[bg=#141414,fg=white] #W #[bg=colour223, fg=black] #I#[bg=default,fg=colour223]\uE0B4 "       # Oculta janelas inativas
set -g window-status-current-format "#[bg=default,fg=#141414]\uE0B6#[bg=#141414,fg=white] #W #[bg=colour223, fg=black] #I#[bg=default,fg=colour223]\uE0B4 "       # Oculta janelas inativas

set -g status-left "#[bg=default, fg=#141414]\uE0B6#[fg=white,bg=#141414]#S #[bg=green,fg=black] #[bg=default,fg=green]\uE0B4  "


#set-option -g status-justify centre
set-option -g status-position top
set-option -g status-left-length 100
set-option -g status-right-length 100
set-option -g status-right-style bg=default,fg=white
set-option -g status-left-style bg=default,fg=white
set -g status-style bg=default,fg=white

set -g status-right "#[bg=default,fg=#141414]\uE0B6#[fg=white,bg=#141414]#{pane_current_path} #[bg=colour223,fg=black]  #[bg=default,fg=colour223]\uE0B4      #[bg=default,fg=#141414]\uE0B6#[bg=#141414,fg=white]%a #[bg=blue,fg=blue].#[bg=blue,fg=black]󰸘#[bg=blue,fg=blue].#[fg=blue bg=default]\uE0B4  #[bg=default,fg=#141414]\uE0B6#[bg=#141414, fg=white]%H:%M #[bg=blue, fg=black] 󰃰 #[bg=default,fg=blue]\uE0B4"



    '';
  };

  programs.git = {
    enable = true;
    userName = "ddaaniel";
    userEmail = "daniel0333v@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.ssh = {
    enable = true;
    includes = ["~/.ssh/config.d/*"];  # Para configurações adicionais
  };
  programs.ssh.matchBlocks = {
    "github.com" = {
      hostname = "github.com";
      identityFile = "~/.ssh/daniel";
      user = "git";
    };
    "gitlab.com" = {
      hostname = "gitlab.com";
      identityFile = "~/.ssh/daniel_gitlab";  # Exemplo com outra chave
      user = "git";
    };
  };

  fonts.fontconfig.enable = true;  # Habilita o gerenciamento de fontes

  home.packages = with pkgs; [
    # Nerd Fonts individuais
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono

    # Outras fontes e pacotes
    font-awesome
    noto-fonts
    noto-fonts-emoji
    htop
  ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
 #home.packages = [
   # Nerd Fonts (com ícones para terminal/IDE)
 #  (nerdfonts.override { fonts = [ "FiraCode" "Hack" "JetBrainsMono" ]; })
   # Font Awesome e outras
 #  font-awesome
 #  noto-fonts
 #  noto-fonts-emoji
 #  pkgs.htop
   # # Adds the 'hello' command to your environment. It prints a friendly
   # # "Hello, world!" when run.
   # pkgs.hello

   # # It is sometimes useful to fine-tune packages, for example, by applying
   # # overrides. You can do that directly here, just don't forget the
   # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
   # # fonts?
   # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

   # # You can also create simple shell scripts directly inside your
   # # configuration. For example, this adds a command 'my-hello' to your
   # # environment:
   # (pkgs.writeShellScriptBin "my-hello" ''
   #   echo "Hello, ${config.home.username}!"
   # '')
 #];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
