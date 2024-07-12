resource "azurerm_resource_group" "velozient_resource_group" {

  name      = var.resource_group
  location  = var.region
  tags      = var.tags

}