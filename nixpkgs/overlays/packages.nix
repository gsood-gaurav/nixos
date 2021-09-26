self: super:

let google-chrome = super.google-chrome.overrideAttrs (oldAttrs: rec {
      name = "google-chrome-${version}";
      src = ./google-chrome-stable_current_amd64.deb;
      version = "93.0.4577.82";
    });
    pyGetwindow = super.python3.pkgs.buildPythonPackage rec {
      pname = "PyGetWindow";
      version = "0.0.9";
      src = super.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "17894355e7d2b305cd832d717708384017c1698a90ce24f6f7fbf0242dd0a688";
      };
      doCheck = false;
      buildInputs = [ pyrect ];
    };
    pyQt5-sip = super.python3.pkgs.buildPythonPackage rec {
      pname = "PyQt5_sip";
      version = "12.9.0";
      src = super.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "d3e4489d7c2b0ece9d203ae66e573939f7f60d4d29e089c9f11daa17cfeaae32";
      };
      doCheck = false;
    };
    pyrect = super.python3.pkgs.buildPythonPackage rec {
      pname = "PyRect";
      version = "0.1.4";
      src = super.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "3b2fa7353ce32a11aa6b0a15495968d2a763423c8947ae248b92c037def4e202";
      };
      doCheck = false;
    };
    # pyqtwebengine = super.python3.pkgs.buildPythonPackage rec {
    #   pname = "PyQtWebEngine";
    #   version = "5.15.4";
    #   src = super.python3.pkgs.fetchPypi {
    #     inherit pname version;
    #     sha256 = "db13f0db983ee2118a3976f646af94417d1279c6b6c0372147c4a3d56c68e58b";
    #     format = "wheel";
    #     python= "cp36.cp37.cp38.cp39";
    #     abi = "abi3";
    #     platform = "manylinux2014_x86_64";
    #   };
    #   doCheck = false;
    # };
    pyqtwebengine = super.python3Packages.pyqtwebengine.overrideAttrs (oldAttrs: { lib = true; pythonPackages = true; qtbase = true; qtwebengine = true; qtsvg=true; buildInputs = oldAttrs.buildInputs; wrapQtAppsHook=true;});
    pyqt5 = super.python3Packages.pyqt5.overrideAttrs (oldAttrs: {qtbase=true; qtconnectivity=true; qtdeclarative=true; qtmultimedia=true; qtsvg=true; qtwebchannel=true; qtwebkit=true; qtwebsockets=true; buildInputs=oldAttrs.buildInputs;});
in
{
  myPackages = super.buildEnv rec {
    name = "my-packages";
    paths = with super; [
      direnv
      gitFull
      gnomeExtensions.dash-to-dock
      texlive.combined.scheme-full
      libreoffice
      ccls
      nix-prefetch-git
      nix-prefetch-github
      jupyter
      python3
      python3Packages.epc
      python3Packages.sexpdata
      #python3Packages.pyqt5_with_qtwebkit
      wmctrl
      nodejs
    ]
    ++
    [
      (hiPrio pyqt5)
      google-chrome
      pyGetwindow
      pyQt5-sip
      pyrect
      pyqtwebengine
    ];
  };
}
