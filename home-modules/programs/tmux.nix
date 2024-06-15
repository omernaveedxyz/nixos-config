{ config, ... }:
{
  programs.tmux = {
    # Whether to enable tmux
    enable = true;

    # Vi or emacs style shortcuts
    keyMode = "vi";

    # Set the $term variable
    terminal = "xterm-256color";

    # Time in milliseconds for which tmux waits after an escape is input
    escapeTime = 0;
  };

  # Extra commands that should be run when initializing an interactive shell
  programs.bash.initExtra = ''
    function tmux-sessionizer {
      folder="$(ls -d ~/Desktop/* | fzf)"
      if [ -z "$TMUX" ]; then
        tmux new-session -A -s "$folder" -c "$folder"
      else
        tmux new-session -d -s "$folder" -c "$folder"
        tmux switch -t "$folder"
      fi
    }

    bind -x '"\C-t":"tmux-sessionizer"'
  '';
}
