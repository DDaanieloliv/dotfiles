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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
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
  ];

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
