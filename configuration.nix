# lil trick to use the _pinned_ evaluation of the config
{
  _module.check = false;
  system.build = {
    _type = "override";
    priority = 0;
    content = (import ./default.nix).config.system.build;
  };
}
