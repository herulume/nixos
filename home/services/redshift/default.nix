{ config, pkgs, ... }:
{
  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };
}
