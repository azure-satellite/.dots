{ config, pkgs, ... }:

with pkgs;

{
  home.packages = [
    python
    (python3Packages.python.buildEnv.override {
      extraLibs = [ python3Packages.pynvim ];
      ignoreCollisions = true;
    })
  ];

  lib.aliases = {
    p2 = "python2";
    p3 = "python3";
  };

  lib.sessionVariables = with config.lib.vars; {
    # Make Python remember history (default repl sucks)
    PYTHONSTARTUP = "${home}/.local/share/python/startup.py";
    IPYTHONDIR = "${home}/.config/jupyter";
    PYTHON_HISTFILE = "${home}/.cache/python_history";
    PIP_LOG = "${home}/.cache/pip/pip.log";
    PYLINTHOME = "${home}/.cache/pylint";
    PYTHON_EGG_CACHE = "${home}/.cache/python-eggs";
  };
}
