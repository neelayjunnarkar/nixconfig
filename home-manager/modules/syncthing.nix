{
  services.syncthing = {
    enable = true;
    # TODO: everything below seems to only work in unstable home-manager.
    # overrideDevices = true;
    # overrideFolders = true;
    # settings = {
    #   devices = {
    #     "phone" = {id = "";};
    #   };
    #   folders = {
    #     "Music" = {
    #       path = "/home/neelay/Music";
    #       devices = ["phone"];
    #       type = "sendonly";
    #     };
    #   };
    # };
  };
}
