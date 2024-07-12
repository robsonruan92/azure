######################
## AZURE SQL SERVER ##
######################

resource "azurerm_mssql_server" "mssql_server" {

  resource_group_name             = azurerm_resource_group.velozient_resource_group.name
  location                        = azurerm_resource_group.velozient_resource_group.location

  name                            = var.mssql_server_name
  version                         = var.mssql_server_version
  administrator_login             = var.mssql_admin_username
  administrator_login_password    = var.mssql_admin_password

  tags = var.tags

}

########################
## AZURE SQL DATABASE ##
########################

resource "azurerm_mssql_database" "mssql_database" {

  name                            = var.mssql_db_name
  server_id                       = azurerm_mssql_server.mssql_server.id
  collation                       = var.mssql_db_collation
  license_type                    = var.mssql_license_type
  sku_name                        = var.mssql_sku_name
  max_size_gb                     = 2
  read_scale                      = false  
  zone_redundant                  = false
  enclave_type                    = null

  tags = var.tags

}
