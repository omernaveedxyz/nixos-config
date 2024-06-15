{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  programs.bash = {
    # Whether to enable GNU Bourne-Again SHell
    enable = true;

    # Whether to enable Bash completion for all interactive Bash shells
    enableCompletion = true;

    # Location of the bash history file
    historyFile = "/home/${config.home.username}/.local/share/bash/history";

    # Extra commands that should be run when initializing an interactive shell
    initExtra = ''
      PS1='\[\e[32;1m\][\u@\h:\w] \[\e[39m\]\$ \[\e[0m\]'
    '';

    # Environment variables that will be sest for the Bash session
    sessionVariables = {
      PROMPT_COMMAND = "history -a; history -c; history -r; $PROMPT_COMMAND";
    };

    # Shell options to set
    shellOptions = [ "histappend" ];
  };

  # The activation scripts blocks to run when activating a Home Manager
  # generation
  home.activation.createBashHistoryDirectoryAndFile =
    mkIf (config.programs.bash.historyFile != null)
      (
        lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          run mkdir -p "$(dirname ${config.programs.bash.historyFile})"
          run touch "${config.programs.bash.historyFile}"
        ''
      );
}
