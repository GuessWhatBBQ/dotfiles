{
  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/9EDC1B6BDC1B3CC9";
    fsType = "ntfs-3g";
    label = "Data";
    options = [
      "nofail"
      "uid=1000"
      "gid=100"
      "dmask=007"
      "fmask=117"
      "x-gvfs-show"
    ];
  };

  fileSystems."/mnt/Data2" = {
    device = "/dev/disk/by-uuid/4919ef0b-a5eb-4011-b631-a50e9ed08196";
    fsType = "btrfs";
    label = "Data2";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };
}
