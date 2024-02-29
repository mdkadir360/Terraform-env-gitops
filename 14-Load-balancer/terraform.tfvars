vms = {
  "frontend" = {
    vmname                 = "kadirfrontendvm"
    network_interface_name = "frontendnic"
  },
  "frontend2" = {
    vmname                 = "kadirbackendvm"
    network_interface_name = "backendnic"
  }
}

probename = "frontendprobe"
port      = "80"
protocol  = "Tcp"
interval  = "5"

lbrule       = "frontendrule"
frontendport = "80"
backendport  = "80"
