keyvault = {
  keyvault1 = {

    name                = "Maktestkey"
    resource_group_name = "test-rg"
    location            = "West Europe"
    sku_name            = "standard"
    location = "westeurope"
  }
}
secret = {
  user = {
    name  = "username"
    value = "adminuser"
  }
  pass = {
    name  = "username"
    value = "adminuser"
  }

}