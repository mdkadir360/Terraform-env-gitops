data "azurerm_network_security_group" "nsgdata" {
    for_each = var.association
  name                = each.value.nsgname
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "subnetdata" {
    for_each = var.association
  name                 = each.value.subnatname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "nsgassosiationblock" {
    for_each = var.association
  subnet_id                 = data.azurerm_subnet.subnetdata[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsgdata[each.key].id
}