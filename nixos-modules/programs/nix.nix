{
  nix = {
    # Whether to enable Nix
    enable = true;

    # Configuration for Nix
    settings = {
      # Enable experimental Nix features
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Nix will automatically detect files in the store that have identical
      # contents, and replaces them with hard links to a single copy
      auto-optimise-store = true;

      # Nix will conform to the XDG Base Directory Specification
      use-xdg-base-directories = true;
    };
  };
}
