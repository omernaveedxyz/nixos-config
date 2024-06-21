{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOrder mkIf;
in
{
  programs.bash = {
    # Whether to enable GNU Bourne-Again SHell
    enable = true;

    # Controlling how commands are saved on the history list
    historyControl = [ "ignoredups" ];

    # Whether to enable Bash completion for all interactive Bash shells
    enableCompletion = true;

    # Location of the bash history file
    historyFile = "${config.xdg.dataHome}/bash/history";

    # Extra commands that should be run when initializing an interactive shell
    initExtra = mkOrder 100 ''
      source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
      PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'; PS1='\[\e[38;5;208;1m\][\u@\h:\w]\[\e[92m\]''${PS1_CMD1}\[\e[38;5;208m\] \$ \[\e[0m\]'
    '';

    # Environment variables that will be sest for the Bash session
    sessionVariables = {
      PROMPT_COMMAND = "history -a; history -c; history -r; $PROMPT_COMMAND";
    };

    # Shell options to set
    shellOptions = [ "histappend" ];
  };

  # The activation scripts blocks to run when activating a Home Manager generation
  home.activation.createBashHistoryDirectoryAndFile =
    mkIf (config.programs.bash.historyFile != null)
      (
        lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          run mkdir -p "$(dirname ${config.programs.bash.historyFile})"
          run touch "${config.programs.bash.historyFile}"
        ''
      );
}
