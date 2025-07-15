

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias btw='echo I_use 󱄅 BTW'

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/p7pmqk7xndkzvaqrkw0kjrq4f746dlxs-bash-completion-2.16.0/etc/profile.d/bash_completion.sh"
fi


 # 󱈸󰋖

 if [ -f "$HOME/.cargo/env" ]; then
   source "$HOME/.cargo/env"
 fi

 if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
   export SDKMAN_DIR="$HOME/.sdkman"
   source "$HOME/.sdkman/bin/sdkman-init.sh"
 fi

 # ~/.bashrc ou ~/.bash_profile
 # if command -v tmux >/dev/null 2>&1; then
 #   # Só executa se for uma shell interativa e estiver em terminal real (evita problemas com VSCode, etc)
 #   if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
 #     tmux attach -t main || tmux new -s main
 #   fi
 # fi

 if [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
   source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
 fi


 # if [ -f "/etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh" ]; then
 #   source "/etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh"
 # fi

 _format_dir() {
   original_user="${SUDO_USER:-$USER}"
   original_home=$(getent passwd "${original_user}" | cut -d: -f6)
   user_tag="~${original_user}"

   if [[ "$PWD" == "$original_home" ]]; then
     echo -n "$user_tag"
   elif [[ "$PWD" == "$original_home/"* ]]; then
     rel_path="${PWD#$original_home/}"
     IFS='/' read -r -a parts <<< "${rel_path}"
     part_count="${#parts[@]}"

     if (( part_count <= 2 )); then
       echo -n "~/$rel_path"
     else
       echo -n "~/.../${parts[-1]}"
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



if [[ $EUID -eq 0 ]]; then
  # Prompt especial para root
  export PS1="\n\n\[$(tput bold)\]\[\033[38;2;255;85;85m\]/ root in \[$(tput sgr0)\]\[\033[38;2;255;255;255m\]\$(_format_dir)\[$(tput sgr0)\]\n\[$(tput bold)\]\[\033[38;2;255;85;85m\]#\[$(tput sgr0)\] "
else
  # Prompt padrão para usuário normal
  export PS1="\n\n\[$(tput bold)\]\[\033[38;2;72;205;232m\]\$(_format_dir)\[$(tput sgr0)\]\$(get_git_info)\n\[$(tput bold)\]\[\033[38;2;66;173;103m\]❱\[$(tput sgr0)\] "
fi
