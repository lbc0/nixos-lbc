{ ... }: {
  programs.opencode = {
    enable = true;

    # This maps to ~/.config/opencode/config.json
    settings = {
      model = "local/your-model-name";
      providers = {
        local = {
          name = "My Local Model";
          api = "openai";
          url = "http://192.168.x.x:PORT/v1";
          apiKey = "local"; # dummy key, required non-empty
          models = [ "your-model-name" ];
        };
      };
    };
  };
}
