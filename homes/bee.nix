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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11"; # Did you read the comment?
}
