{ config, pkgs, lib, inputs, ... }:

let
  damxSrc = inputs.damx;

  linuwu-sense = config.boot.kernelPackages.callPackage ({ stdenv, kernel }: stdenv.mkDerivation {
    name = "linuwu-sense";
    src = damxSrc + "/Linuwu-Sense";
    nativeBuildInputs = kernel.moduleBuildDependencies;
    makeFlags = [
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "KVER=${kernel.modDirVersion}"
    ];
    installPhase = ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86
      cp src/linuwu_sense.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/
    '';
  }) {};

  damx-daemon = pkgs.stdenv.mkDerivation {
    name = "damx-daemon";
    src = damxSrc + "/DAMX-Daemon";
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.zlib pkgs.stdenv.cc.cc.lib ];
    installPhase = ''
      mkdir -p $out/bin
      cp DAMX-Daemon $out/bin/damx-daemon
      chmod +x $out/bin/damx-daemon
    '';
  };

  damx-gui = pkgs.buildFHSEnv {
    name = "DivAcerManagerMax";
    targetPkgs = pkgs: with pkgs; [
      zlib stdenv.cc.cc.lib
      libx11 libxext libxcursor libxrandr libxi libxinerama libxxf86vm libxcb
      libGL alsa-lib pango cairo atk gtk3 glib nss nspr dbus
      udev wayland libxkbcommon icu fontconfig libice libsm
    ];
    profile = ''
      export PATH=$PATH:/run/current-system/sw/bin
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/run/opengl-driver/lib
      export GDK_BACKEND=wayland,x11
    '';
    runScript = "${damxSrc}/DAMX-GUI/DivAcerManagerMax";
  };

  damx-desktop = pkgs.makeDesktopItem {
    name = "damx";
    desktopName = "DAMX";
    exec = "DivAcerManagerMax --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations";
    icon = "${damxSrc}/DAMX-GUI/icon.png";
    categories = [ "System" "Settings" ];
    comment = "Acer Laptop WMI Controls for Linux";
  };
in
{
  boot.extraModulePackages = [ linuwu-sense ];
  boot.kernelModules = [ "linuwu_sense" ];
  boot.blacklistedKernelModules = [ "acer_wmi" ];
  boot.extraModprobeConfig = ''
    options linuwu_sense enable_all=1
  '';

  systemd.services.damx-daemon = {
    description = "DAMX Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.evtest pkgs.kmod pkgs.sudo pkgs.bash pkgs.coreutils ];
    serviceConfig = {
      ExecStart = "${damx-daemon}/bin/damx-daemon";
      Restart = "on-failure";
      User = "root";
    };
  };

  environment.systemPackages = [ damx-gui pkgs.evtest damx-desktop ];
  
  users.groups.linuwu_sense = {};
  users.users.hinne.extraGroups = [ "linuwu_sense" ];

  # Udev rules to set permissions for the driver sysfs files so the GUI can access them
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="module", KERNEL=="linuwu_sense", RUN+="${pkgs.bash}/bin/bash -c 'sleep 1; chgrp -R linuwu_sense /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi; chmod -R g+rw /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi'"
  '';
}
