local local_config = {
  ssh_domains = {
    {
      name = "Daemon-Raspi1", -- This name identifies the domain
      remote_address = "192.168.2.181", -- The address to connect to
      username = "daephx", -- The username to use on the remote host
    },
  },
}

return local_config
