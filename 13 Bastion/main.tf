data "azurerm_subnet" "subnetdata" {
  for_each             = var.bastionhost
  name                 = each.value.subnetname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
data "azurerm_public_ip" "ipdata" {
  for_each            = var.bastionhost
  name                = each.value.ipname
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_bastion_host" "bastionblock" {
  for_each            = var.bastionhost
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.subnetdata[each.key].id
    public_ip_address_id = data.azurerm_public_ip.ipdata[each.key].id
  }
}