data "azurerm_mssql_server" "serdata" {
  for_each = var.sqldata
  name                =each.value.servername
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_mssql_database" "datablock" {
    for_each = var.sqldata
  name           = each.value.name
  server_id      = data.azurerm_mssql_server.serdata[each.key].id
   collation      = "SQL_Latin1_General_CP1_CI_AS"
   license_type   = "LicenseIncluded"
  max_size_gb    = 4
   read_scale     = true
   sku_name       = "S0"
   zone_redundant = true
   enclave_type   = "VBS"
}
