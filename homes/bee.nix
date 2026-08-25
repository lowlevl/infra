{
  config,
  self,
  pkgs,
  ...
}: {
  imports = with self.homeModules; [
    hm
    pam
    shell
    neovim
    nixgl
    X
  ];

  # Authentication quirks with PAM
  home.pam = {
    chkpwdPath = "/usr/bin/unix_chkpwd";
    overridePackages = ["i3lock-color"];
  };

  nixpkgs.config.allowUnfree = true;

  # Enable `git-annex assistant` on startup and append it the i3status config
  home.packages = [
    pkgs.pv

    (config.lib.nixGL.wrap pkgs.musescore)
    (config.lib.nixGL.wrap pkgs.stremio-linux-shell)
    (pkgs.proxmark3.override {withBlueshark = true;})
  ];

  services.syncthing = {
    enable = true;
    tray.enable = true;

    settings = {
      options.urAccepted = -1;

      devices."hypnos.unw.re".id = "5AL4FWV-ZNRXL2O-ZCUOADE-7EUKI5G-WZF2MPA-MGVIPK2-KYH3SHT-F6XSJQJ";
      folders."~/Library" = {
        devices = ["hypnos.unw.re"];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11"; # Did you read the comment?
}
