with import <nixpkgs> {};

mkShell {
  name = "test";
  buildInputs = [ clang dbus dbus_libs python38 ];
  pathsToLink = [ "/share/man" "/share/doc" ];
  extraOutputsToInstall = [ "man" "doc" ];
  shellHook = ''
  export LIBCLANG_PATH="${llvmPackages.libclang}/lib";
  export PATH=$PATH:/nix/store/zbvj02i6gl4x95l6iazrzdjzg2cwhd5d-ccls-0.20190823.5/bin/:/nix/store/268swz1wq5p8cbbll580vv0mgqm0n4an-clang-wrapper-7.1.0/bin/
  '';
}

  
