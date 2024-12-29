{pkgs ? import <nixpkgs> {}}:
(pkgs.buildFHSEnv {
  name = "shell";
  targetPkgs = pkgs: (with pkgs; [
    haxe
    neko
    nodejs
    just
    (with xorg; [libX11 libXext libXinerama libXi libXrandr])
  ]);
  runScript = "bash";
  profile = ''
    export LD_LIBRARY_PATH=${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXext}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libXi}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.libGL}/lib
  '';
})
.env
