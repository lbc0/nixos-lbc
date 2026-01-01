{ ... }:
{
  users.users.lbc = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
