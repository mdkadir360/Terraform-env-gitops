data "azurerm_network_interface" "nicdata" {
  for_each = var.vm
   name                = each.value.nicname
  resource_group_name = each.value.resource_group_name
}
# data "azurerm_key_vault" "secret" {
#   name                = "Kadirkeyvault"
#   resource_group_name = "kadir_key_vault-rg"
# }
# data "azurerm_key_vault_secret" "username" {
#   name         = "username"
#   key_vault_id = data.azurerm_key_vault.secret.id
# }
# data "azurerm_key_vault_secret" "password" {
#   name         = "password"
#   key_vault_id = data.azurerm_key_vault.secret.id
# }



resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.vm
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  size                  = "Standard_F2"
  admin_username        = "adminuser"
  admin_password        = "adminuser@1234"
  network_interface_ids = [data.azurerm_network_interface.nicdata[each.key].id]
 disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
connection {
  host = self.public_ip_address
  user = self.admin_username
  password = self.admin_password
  type = "ssh"
  timeout = "4m"
}
provisioner "file" {
  source = "index.html"
  destination = "/tmp/index.html"
  
}

provisioner "remote-exec" {
   inline = [ 
    "sudo apt update",
    "sudo apt install nginx -y",
    "sudo cp /tmp/index.html /var/www/html"
   ]
}

provisioner "local-exec" {
  command = "echo Everything is fine > Everything is OK.txt"
  
}

}