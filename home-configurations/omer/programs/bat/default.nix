{ pkgs, ... }:
{
  programs.bat = {
    # Whether to enable bat, a cat clone with wings
    enable = true;

    # Additional syntaxes to provide
    syntaxes = {
      just = {
        src = pkgs.fetchFromGitHub {
          owner = "nk9";
          repo = "just_sublime";
          rev = "352bae277961d41e2a1795a834dbf22661c8910f";
          hash = "sha256-QCp6ypSBhgGZG4T7fNiFfCgZIVJoDSoJBkpcdw3aiuQ=";
        };
        file = "Syntax/Just.sublime-syntax";
      };
    };
  };
}
