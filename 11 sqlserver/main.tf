data "azurerm_key_vault" "secret" {
  name                = "Kadirkeyvault"
  resource_group_name = "kadir_key_vault-rg"
}
data "azurerm_key_vault_secret" "username" {
  name         = "username"
  key_vault_id = data.azurerm_key_vault.secret.id
}
data "azurerm_key_vault_secret" "sqlpassword" {
  name         = "sql-password"
  key_vault_id = data.azurerm_key_vault.secret.id
}

resource "azurerm_mssql_server" "serverblock" {
    for_each = var.sqlserver
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.username.value
  administrator_login_password = data.azurerm_key_vault_secret.sqlpassword.value
  minimum_tls_version          = "1.2"
}