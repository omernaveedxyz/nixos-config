{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf mkOptionDefault;
  inherit (pkgs) writeShellScriptBin;

  previewer = writeShellScriptBin "pv.sh" ''
    file=$1
    w=$2
    h=$3

    if [[ "$( ${getExe pkgs.file} -Lb --mime-type "$file")" =~ ^image ]]; then
      ${getExe pkgs.chafa} -f sixel -s "$wx$h" --animate off --polite on "$file"
      exit 1
    elif [[ "$( ${getExe pkgs.file} -Lb --mime-type "$file")" =~ ^video ]]; then
      ${getExe pkgs.ffmpegthumbnailer} -i "$file" -s 0 -q 5 -o /tmp/preview.png
      ${getExe pkgs.chafa} -f sixel -s "$wx$h" --animate off --polite on /tmp/preview.png
      exit 1
    fi

    ${getExe pkgs.pistol} "$file"
  '';
in
{
  programs.lf = {
    # Whether to enable lf
    enable = true;

    # An attribute set of lf settings
    settings = {
      # Draw boxes around panes with box drawing characters
      drawbox = true;

      # Show icons before each item in the list
      icons = true;

      # Render sixel images in preview
      sixel = true;
    };

    # Script or executable to use to preview files
    previewer.source = "${previewer}/bin/pv.sh";

    # Commands to declare
    commands = {
      trash = "%${pkgs.trash-cli}/bin/trash-put \"$fx\"";
      trash-restore = ''''${{${pkgs.trash-cli}/bin/trash-restore}}'';
      trash-empty = ''''${{${pkgs.trash-cli}/bin/trash-empty}}'';

      fzf_jump = ''
        ''${{
          res="$(find . -maxdepth 1 | fzf --reverse --header='Jump to location')"
          if [ -n "$res" ]; then
            if [ -d "$res" ]; then
              cmd="cd"
            else
              cmd="select"
            fi
            res="$(printf '%s' "$res" | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id $cmd \"$res\""
          fi
        }}
      '';

      fzf_search = ''
        ''${{
          RG_PREFIX="${getExe pkgs.ripgrep} --column --line-number --no-heading --color=always --smart-case "
          res="$(
            FZF_DEFAULT_COMMAND="$RG_PREFIX '''" \
              fzf --bind "change:reload:$RG_PREFIX {q} || true" \
              --ansi --layout=reverse --header 'Search in files' \
              | cut -d':' -f1 | sed 's/\\/\\\\/g;s/"/\\"/g'
          )"
          [ -n "$res" ] && lf -remote "send $id select \"$res\""
        }}
      '';
    };

    # Keys to bind
    keybindings = {
      "<delete><delete>" = "trash";
      "<delete>r" = "trash-restore";
      "<delete>c" = "trash-empty";

      "<c-f>" = ":fzf_jump";
      "gs" = ":fzf_search";
    };
  };

  # Path of the source file or directory
  xdg.configFile."lf/icons".source = ./icons;

  wayland.windowManager.sway = mkIf (config.wayland.windowManager.sway.enable) {
    # Sway configuration options
    config = {
      # An attribute set that assigns a key press to an action using a key symbol
      keybindings = mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+f" = "exec ${config.home.sessionVariables.TERMINAL} -e ${getExe config.programs.lf.package}";
      };
    };
  };

  # An attribute set that assigns a key press to an action using a key symbol
  wayland.windowManager.hyprland = mkIf (config.wayland.windowManager.hyprland.enable) {
    settings.bind = [
      "$Mod Shift, f, exec, ${config.home.sessionVariables.TERMINAL} -e ${getExe config.programs.lf.package}"
    ];
  };
}
