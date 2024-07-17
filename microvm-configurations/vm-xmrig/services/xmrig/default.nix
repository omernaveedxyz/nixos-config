{
  services.xmrig = {
    # Whether to enable XMRig Mining Software
    enable = true;

    # XMRig configuration
    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = false;
      pools = [
        {
          url = "pool.hashvault.pro:443";
          user = "88ZcCqXvZuiPBFbfdne48QgFT2s5ozmH611siwKnD13hD7YsDmSRiXeG6ZZ6t5tNVDgyFbFFxAJRmeB1hwLaLWtH68iwNXv";
          keepalive = true;
          tls = true;
        }
      ];
    };
  };
}
