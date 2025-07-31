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
      btw = "echo I_use 󱄅 BTW";
      vim = "nvim";
      l = "ls -la";
    };
    initExtra = ''

      # 󱈸󰋖

      # ~/.bashrc ou ~/.bash_profile
      # if command -v tmux >/dev/null 2>&1; then
      #   # Só executa se for uma shell interativa e estiver em terminal real (evita problemas com VSCode, etc)
      #   if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
      #     tmux attach -t main || tmux new -s main
      #   fi
      # fi

			# enable color support of ls and also add handy aliases
			if [ -x /usr/bin/dircolors ]; then
					test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
					alias ls='ls --color=auto'
					#alias dir='dir --color=auto'
					#alias vdir='vdir --color=auto'

					alias grep='grep --color=auto'
					alias fgrep='fgrep --color=auto'
					alias egrep='egrep --color=auto'
			fi


      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


      if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
      fi

      if [ -f "$HOME/.node_env" ]; then
        source "$HOME/.node_env"
      fi


      if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
        export SDKMAN_DIR="$HOME/.sdkman"
        source "$HOME/.sdkman/bin/sdkman-init.sh"
      fi


      if [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
        source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
      fi


      # if [ -f "/etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh" ]; then
      #   source "/etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh"
      # fi

      _format_dir() {
        original_user="''${SUDO_USER:-$USER}"
        original_home=$(getent passwd "''${original_user}" | cut -d: -f6)
        user_tag="~''${original_user}"

        if [[ "$PWD" == "$original_home" ]]; then
          echo -n "$user_tag"
        elif [[ "$PWD" == "$original_home/"* ]]; then
          rel_path="''${PWD#$original_home/}"
          IFS='/' read -r -a parts <<< "''${rel_path}"
          part_count="''${#parts[@]}"

          if (( part_count <= 2 )); then
            echo -n "~/$rel_path"
          else
            echo -n "~/.../''${parts[-1]}"
          fi
        else
          echo -n "$PWD"
        fi
      }

      get_git_info() {
        git_dir=$(git rev-parse --git-dir 2>/dev/null)
        [ -n "$git_dir" ] && {
          branch=$(git branch --show-current 2>/dev/null)
                [ -n "$branch" ] && echo -e " on \001\033[1;38;2;207;62;139m\002(\ue0a0 \001\033[1;38;2;207;62;139m\002$branch)\001\033[0m\002"
        }
      }


      __timer_start() {
        __timer=''${__timer:-$SECONDS}
      }

      __timer_stop() {
        local exit_code=$?
        __timer_show=$((SECONDS - __timer))
        unset __timer

        if [[ -n "$__timer_show" && "$__timer_show" -ge 1 ]]; then
          # Texto completo com ícone ( é o ícone de relógio)
          local timer_text=" ''${__timer_show}s"
          # Calcula o tamanho REAL (considerando caracteres unicode)
          local timer_length=$(printf "%s" "$timer_text" | wc -m)
          local cols=$(tput cols)
        
          # Posicionamento à prova de quebras:
          printf "\033[s"               # Salva posição
          printf "\033[1A"              # Sobe para a linha do output
          printf "\033[''${cols}G"      # Vai para o canto direito absoluto
          printf "\033[''${timer_length}D" # Retrocede exatamente o necessário
          printf "\033[38;5;242m%s" "$timer_text"  # Imprime o timer
          printf "\033[u"               # Restaura posição
        fi

        unset __timer_show
        return $exit_code
      }

      trap '__timer_start' DEBUG
      PROMPT_COMMAND=__timer_stop


      if [[ $EUID -eq 0 ]]; then
        # Prompt especial para root (com formatação igual ao usuário comum)
        export PS1="\n\[$(tput bold)\]\[\033[38;2;220;124;126m\]root\[$(tput sgr0)\] in \[$(tput bold)\]\[\033[38;2;72;205;232m\]\$(_format_dir)\[$(tput sgr0)\]\n\[$(tput bold)\]\[\033[38;2;66;173;103m\]❱\[$(tput sgr0)\] "
      else
        # Prompt padrão para usuário normal
        export PS1="\n\[$(tput bold)\]\[\033[38;2;72;205;232m\]\$(_format_dir)\[$(tput sgr0)\]\$(get_git_info)\n\[$(tput bold)\]\[\033[38;2;66;173;103m\]❱\[$(tput sgr0)\] "
      fi


    '';
  };

  programs.tmux = {
    enable = true;

    # ===== Configurações Principais =====
    baseIndex = 1; # Começa janelas em 1
    clock24 = true; # Relógio em 24h
    escapeTime = 10; # Tempo de escape (ms)
    historyLimit = 8000;
    mouse = true; # Ativa mouse

    # ===== Prefix Key =====
    prefix = "C-a"; # Muda prefix para Ctrl+a

    # ===== Terminal =====
    terminal = "tmux-256color";

    # ===== Keybindings =====
    extraConfig = ''

      # Configuração de cores e terminal
      #set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",xterm-256color:RGB"
      set -ga terminal-overrides ",alacritty:RGB"
      set -ga terminal-overrides ",xterm-kitty:RGB"
      set -ga terminal-overrides ",gnome*:RGB"

      # Melhores binds para splits
      bind -n C-\\ split-window -h -c "#{pane_current_path}"
      bind -n C-] split-window -v -c "#{pane_current_path}"
      bind -n C-t new-window -c "#{pane_current_path}"
      bind -n C-x kill-pane

      # bind -n C-r source-file ~/.config/tmux/tmux.conf 
			bind-key r source-file ~/.config/tmux/tmux.conf \; run-shell "tmux move-window -r"

      # Binds alternativos
      bind -n M-Left resize-pane -L 1   # Alt+Left
      bind -n M-Right resize-pane -R 1  # Alt+Right
      bind -n M-Down resize-pane -D 1   # Alt+Down
      bind -n M-Up resize-pane -U 1     # Alt+Up

      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      bind-key -n C-p previous-window
      bind-key -n C-n next-window

			# Mover janela para a esquerda (swap com a anterior)
			bind-key - swap-window -t -1

			# Mover janela para a direita (swap com a próxima)
			bind-key + swap-window -t +1

      # Suporte ao clipboard
			set -g set-clipboard on  # Habilita o básico


			# Habilita keybindings no estilo Vim
			set-window-option -g mode-keys vi

			# Apenas o essencial para evitar concatenação (Linux exemplo):
			bind -T copy-mode-vi MouseDragEnd1Pane \
					send-keys -X copy-pipe "echo -n | xclip -selection clipboard -in; xclip -selection clipboard -in"

			bind-key -T copy-mode-vi y \
					send-keys -X copy-pipe "echo -n | xclip -selection clipboard -in; xclip -selection clipboard -in"


			# Atalhos para entrar no modo de cópia (como o Vim)
			bind-key -T copy-mode-vi v send-keys -X begin-selection  # Entra em modo visual
			# bind-key -T copy-mode-vi y send-keys -X copy-selection  # Copia seleção (como 'y' no Vim)
			bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle  # Modo bloco (visual block)

			# Opcional: Tecla para sair do modo de cópia (Esc como no Vim)
			bind-key -T copy-mode-vi Escape send-keys -X cancel


			#set-option -g status-justify centre
			set-option -g status-position top
			set-option -g status-left-length 100
			set-option -g status-right-length 100
			set-option -g status-right-style bg=default,fg=white
			set-option -g status-left-style bg=default,fg=white
			set -g status-style bg=default,fg=white

			set -g window-status-format "#[bg=default,fg=#342838]\uE0B6#[bg=#342838,fg=white]#W #[bg=colour223, fg=black] #I#[bg=default,fg=colour223]\uE0B4 "       # Oculta janelas inativas
			set -g window-status-current-format "#[bg=default,fg=#342838]\uE0B6#[bg=#342838,fg=white] #W #[bg=#e3a1a1, fg=black] #I#[bg=default,fg=#e3a1a1]\uE0B4 "       # Oculta janelas inativas

			set -g status-left "#[bg=default, fg=green]\uE0B6#[bg=green,fg=black] #[fg=white,bg=#342838] #S#[bg=default,fg=#342838]\uE0B4  "


			set -g status-right "#[bg=default,fg=#f77ee5]\uE0B6#[bg=#f77ee5,fg=black] #[fg=white,bg=#342838] #(short-path #{pane_current_path})#[bg=default,fg=#342838]\uE0B4  #[bg=default,fg=blue]\uE0B6#[bg=blue,fg=black]󰸘 #[bg=#342838,fg=white] %d#[bg=default,fg=#342838]\uE0B4  #[bg=default,fg=blue]\uE0B6#[bg=blue, fg=black]󰃰 #[bg=#342838, fg=white] %H:%M#[bg=default,fg=#342838]\uE0B4"

    '';
  };

  programs.git = {
    enable = true;
    userName = "ddaaniel";
    userEmail = "daniel0333v@gmail.com";
    extraConfig = { init.defaultBranch = "main"; };
  };

  programs.ssh = {
    enable = true;
    # Opcional: inclui outros arquivos de configuração (útil para configurações adicionais)
    includes = [ "~/.ssh/config.d/*" ];

    # Define blocos de configuração para hosts específicos (GitHub, GitLab, etc.)
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/Tdan"; # 🔥 Ajuste para o nome REAL da sua chave
        user = "git"; # Usuário padrão do GitHub
        identitiesOnly = true; # Força usar APENAS a chave especificada
      };

      # Exemplo para GitLab (se necessário)
      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = "~/.ssh/Tdan"; # Se você tiver outra chave para o GitLab
        user = "git";
      };
    };
  };

  fonts.fontconfig.enable = true; # Habilita o gerenciamento de fontes

  # The home.packages option allows you to install Nix packaes into your
  # environment.
  home.packages = with pkgs; [
    # Nerd Fonts individuais
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono

    # Outras fontes e pacotes
    font-awesome
    noto-fonts
    noto-fonts-emoji

    mesa # Já inclui OpenGL e Vulkan
    libva-utils # Para vainfo
    htop
    cava
    chafa
    tree
    nitch
    ripgrep
    xclip
    lua-language-server
    lm_sensors
		maven
    (pkgs.writeShellScriptBin "short-path" ''
      path="''${1:-$PWD}"
      home="$HOME"

      if [ "$path" = "$home" ]; then
        echo "~daniel"
      else
        path="''${path#$home/}"
        IFS='/' read -r -a parts <<< "$path"
        len="''${#parts[@]}"

        if (( len >= 2 )); then
          folder1="''${parts[len-2]}"
          folder2="''${parts[len-1]}"
        elif (( len == 1 )); then
          folder1=""
          folder2="''${parts[0]}"
        else
          folder1=""
          folder2=""
        fi

        truncate() {
          if [ "''${#1}" -gt 10 ]; then
            echo "''${1:0:7}…"
          else
            echo "$1"
          fi
        }

        folder1_short="$(truncate "$folder1")"
        folder2_short="$(truncate "$folder2")"

        if [ -n "$folder1_short" ]; then
          echo ".../$folder1_short/$folder2_short"
        else
          echo ".../$folder2_short"
        fi
      fi
    '')

    # Adds the 'hello' command to your environment. It prints a friendly
    # "Hello, world!" when run.
    # pkgs.hello

    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?

    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your
    # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    ".config/kitty/kitty.conf".text = ''
      term xterm-256color 

      # #1B1C26 #090f14
      background #1a1b26
      background_opacity 0.95

      enable_audio_bell no

      # Frappé Color Scheme for Kitty Terminal
      # Base Colors
      color0 #232634
      color8 #626880

      # Reds
      color1 #e78284
      color9 #ea999c

      # Greens
      color2 #a6d189
      color10 #81c8be

      # Yellows
      color3 #e5c890
      color11 #ef9f76

      # Blues
      color4 #8caaee
      color12 #85c1dc

      # Magentas
      color5 #ca9ee6
      color13 #f4b8e4

      # Cyans
      color6 #99d1db
      color14 #babbf1

      # Whites
      color7 #c6d0f5
      color15 #ffffff

      font_family Hack Nerd Font
      font_size 12.9

      window_padding_width 10

      tab_bar_style hidden
    '';

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

