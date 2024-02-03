# data "azurerm_resource_group" "rgdata" {
#   for_each = var.appgateway
#   name     = each.value.resource_group_name
#   location = each.value.location
# }

# data "azurerm_virtual_network" "vnetdata" {
#   for_each = var.appgateway
#   name                = each.value.virtual_network_name
#  resource_group_name = each.value.resource_group_name
# }

data "azurerm_subnet" "subnetdata" {

  name                 = var.subnet
  virtual_network_name =var.virtual_network_name
  resource_group_name  = var.resource_group_name
}
# data "azurerm_subnet" "backend" {
#   name                 = "backend"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

data "azurerm_public_ip" "ipdata" {
 
  name                = var.ipname
  resource_group_name = var.resource_group_name
}
# since these variables are re-used - a locals block makes this more maintainable
# locals {
#   backend_address_pool_name      = "beap"
#   frontend_port_name             = "feport"
#   frontend_ip_configuration_name = "feip"
#   http_setting_name              = "be-htst"
#   listener_name                  = "httplstn"
#   request_routing_rule_name      = "rqrt"
# }

resource "azurerm_application_gateway" "network" {

  name                = var.gatewayname
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.subnetdata.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.ipdata.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    priority                   = 25
    http_listener_name         = var.http_listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
  }
}

data "azurerm_network_interface" "vminterface" {
  for_each            = var.appgatewayassociation
  name                = each.value.network_interface_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appassoblock" {
  for_each = var.appgatewayassociation
depends_on = [ azurerm_application_gateway.network ]
  network_interface_id    = data.azurerm_network_interface.vminterface[each.key].id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = tolist(azurerm_application_gateway.network.backend_address_pool).0.id
}