{
  nix = {
    # Whether to enable the Nix configuration module
    enable = true;

    # Configuration for Nix
    settings = {
      # Nix will conform to the XDG Base Directory Specification
      use-xdg-base-directories = true;
    };
  };
}
