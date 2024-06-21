{ pkgs, ... }:
{
  services.gpg-agent = {
    # Whether to enable gnupg private key agent
    enable = true;

    # Whether to enable socket of the gnupg key agent
    enableExtraSocket = true;

    # Whether to use gnupg key agent for ssh keys
    enableSshSupport = true;

    # Which pinentry interface to use
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
