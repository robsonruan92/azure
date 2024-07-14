resource "random_string" "resource_group_name" {
  length  = 10
  special = false
  upper   = false
}

resource "random_string" "storage_name" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "velozient_resource_group" {

  name                      = "${random_string.resource_group_name.result}"
  location                  = var.region
  tags                      = var.tags

}

resource "azurerm_storage_account" "storage_account" {

  resource_group_name       = azurerm_resource_group.velozient_resource_group.name
  location                  = azurerm_resource_group.velozient_resource_group.location

  name                      = "${random_string.storage_name.result}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"

  tags                      = var.tags
}