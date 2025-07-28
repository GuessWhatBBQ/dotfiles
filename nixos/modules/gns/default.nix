{
  services.gns3-server = {
    enable = false;
    ubridge.enable = true;
    vpcs.enable = true;
    dynamips.enable = true;
    settings = {
      Server = {
        host = "127.0.0.1";
        port = 3080;
      };
      Dynamips = {
        allocate_aux_console_ports = "False";
        ghost_ios_support = "True";
        sparse_memory_support = "True";
        mmap_support = "True";
      };
    };
  };
}
