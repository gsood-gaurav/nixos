with import <nixpkgs> {};

# mkShell {
# name = "python-shell";
# buildInputs = [ python3 python3Packages.dbus-python python3Packages.pygobject3 python3Packages.pyqt5 python3Packages.pip python3Packages.setuptools python3Packages.flake8 python3Packages.jedi ];
# }

let
  pythonEnv = python3.withPackages (ps: [
    ps.dbus-python
    ps.pygobject3
    ps.pyqt4
    ps.pip
    ps.setuptools
    ps.flake8
    ps.jedi
    ps.rope
    ps.autopep8
    ps.yapf
    ps.jupyter
    ps.tensorflow
    ps.tensorflow-tensorboard
    ps.tensorflow-estimator
    ps.numpy
    ps.scipy
    ps.pandas
    ps.matplotlib
    ps.transformers
    ps.torchvision
    ps.tqdm
    ps.tokenizers
    ps.nltk
    ps.sentencepiece
    ps.scikit-learn
    ps.requests
    ps.filelock
    ps.typing-extensions
    ps.importlib-metadata
    ps.packaging
    #ps.python-language-server
    ps.jupyter
    ps.pluggy
    ps.ujson
  ]);
  my-dbus-next = python3.pkgs.buildPythonPackage rec {
    pname = "dbus_next";
    version = "0.2.3";
    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "4dd9097778224c69228f7f2a0f52e9b13ec2c75e87974ad312525c927835e8fb";
    };
      doCheck = false;
      meta = {
        homepage = "https://github.com/acrisci/python-dbus-next";
        description = "A zero-dependency DBus library for Python with asyncio support";
    };
  };
  tf-metrics = python3.pkgs.buildPythonPackage rec {
    name = "tf-metrics";
    version = "";
    src = ./tf_metrics.tar.xz;
    propagatedBuildInputs = with python3.pkgs; [ tensorflow  ];

  };

  tensorflow-addons = python3.pkgs.buildPythonPackage rec {
    pname = "addons";
    version = "0.14.0";
    src = fetchFromGitHub {
      repo = "addons";
      owner = "tensorflow";
      rev = "v0.14.0";
      sha256 = "1p04mavmpzrlm28vs6qbvdqpvpiyc4wsdj83n67knzws1pk71blx";
    };
    doCheck = false;
    propagatedBuildInputs = with python3.pkgs; [ typeguard ];
    meta = {
      homepage = "https://github.com/tensorflow/addons";
    };
  };

  huggingface-hub = python3.pkgs.buildPythonPackage rec {
    pname = "huggingface_hub";
    version = "0.0.16";
    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1rha230qbchz2692z5sw2adnmvryy7cx9l2cvjv4s932xxm14hk7";
    };
    doCheck = false;
    propagatedBuildInputs = with python3.pkgs; [ requests typing-extensions tqdm importlib-metadata packaging filelock ];
  };

  tensorflow-metadata = python3.pkgs.buildPythonPackage rec {
    pname = "metadata";
    version = "1.2.0";
    src = fetchFromGitHub {
      repo = "metadata";
      owner = "tensorflow";
      rev = "v1.2.0";
      sha256 = "0c00kzkwa0abjcc4m8lz8sgjg1bdcxrmikc90n4kcdfs5y2wgq54";
    };
    nativeBuildInputs = [ bazel ];
    meta = {
      homepage = "https://github.com/tensorflow/metadata";
    };
  };


  tensorflow-datasets = python3.pkgs.buildPythonPackage rec {
    pname = "tensorflow-datasets";
    version = "4.4.0";
    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0q5rx7jpb9yh4ca42qnkdxn3vq9inp8vw3dwv82ppnqzxhfsd59y";
    };
    doCheck = false;
    propagatedBuildInputs = with python3.pkgs; [ absl-py ];
    meta = {
      homepage = "https://github.com/tensorflow/datasets";
    };
  };


 tensorflow-text = python3.pkgs.buildPythonPackage rec {
    pname = "text";
    version = "2.6.0";
    src = fetchFromGitHub {
      repo = "text";
      owner = "tensorflow";
      rev = "v2.6.0";
      sha256 = "1f2k3n2p2fj22ja5w27l3zqyxyis9hklkjb9blank2739sxl6dk0";
    };
    doCheck = false;
    meta = {
      homepage = "https://github.com/tensorflow/text";
    };
 };


 python-lsp-jsonrpc = python3.pkgs.buildPythonPackage rec {
   pname = "python-lsp-jsonrpc";
   version = "1.0.0";
   src = fetchFromGitHub {
     repo = "python-lsp-jsonrpc";
     owner = "python-lsp";
     rev = "v1.0.0";
     sha256 = "0h4bs8s4axcm0p02v59amz9sq3nr4zhzdgwq7iaw6awl27v1hd0i";
   };
   doCheck = false;
   buildInputs = with python3.pkgs; [ ujson ];
   meta = {
     homepage = "https://github.com/python-lsp/python-lsp-jsonrpc";
   };
 };


 python-lsp-server = python3.pkgs.buildPythonPackage rec {
   pname = "python-lsp-server";
   version = "1.2.2";
   src = fetchFromGitHub {
     repo = "python-lsp-server";
     owner = "python-lsp";
     rev = "v1.2.2";
     sha256 = "048yr1yfdpi9cdr8sl7fmgp7kyn046jx7q4shnnqjfqyyq55zrj6";
   };
   buildInputs = with python3.pkgs; [ jedi ujson python-lsp-jsonrpc pluggy
                                      pytest flaky yapf rope pylint pyflakes pycodestyle autopep8 pydocstyle ];
   meta = {
     homepage = "https://github.com/python-lsp/python-lsp-server";
   };
 };

  
in mkShell {
  buildInputs = [
    unzip
    pythonEnv
    tf-metrics
    huggingface-hub
    python-lsp-server
    python-lsp-jsonrpc
#    python38Packages.python-language-server
  ];
  shellHook = ''
export PATH=/nix/store/c1iakn8yk5racphsg9d172gn7kp1hhh2-python3-3.8.9-env/lib:$PATH
'';
}
