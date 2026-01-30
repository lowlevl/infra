{
  config,
  lib,
  ...
}: let
  cfg = config.home.pam;
in {
  options.home.pam = {
    chkpwdPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        System path for the `unix_chkpwd` SUID binary.

        This option is required to be changed on non-NixOS systems:
        PAM depends on a working SUID binary in an hard-coded path
        which is not populated in non-NixOS systems.

        In Arch/Manajaro this is `/usr/bin/unix_chkpwd`.
      '';
    };

    overridePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["i3lock" "i3lock-color" "xsecurelock"];
      description = ''
        Nixpkgs to override with the patched PAM.

        This option will setup an overlay providing the patched
        {pkgs}`linux-pam` to each specified package.
      '';
    };
  };

  config = lib.mkIf (cfg.chkpwdPath != null) (
    let
      postPatch = ''
        substituteInPlace modules/module-meson.build \
          --replace-fail "sbindir / 'unix_chkpwd'" "'${cfg.chkpwdPath}'"
      '';

      overlay = self: super: let
        pam = super.linux-pam.overrideAttrs (old: {inherit postPatch;});
      in
        lib.mergeAttrsList (lib.map (
            pkg: {"${pkg}" = super."${pkg}".override {inherit pam;};}
          )
          cfg.overridePackages);
    in {
      nixpkgs.overlays = [overlay];
    }
  );
}
