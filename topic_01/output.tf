output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "resource_group" {
  value = azurerm_resource_group.velozient_resource_group.name
}

output "azurerm_mssql_server" {
  value = azurerm_mssql_server.mssql_server.name
}

output "azurerm_mssql_database" {
  value = azurerm_mssql_database.mssql_database.name
}