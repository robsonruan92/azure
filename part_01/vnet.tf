##########
## VNET ##
##########

resource "azurerm_virtual_network" "vnet_01" {

  resource_group_name = azurerm_resource_group.velozient_resource_group.name
  location            = azurerm_resource_group.velozient_resource_group.location
  
  name                = var.vnet_name
  address_space       = var.cidr_vnet_01

  tags = var.tags
  
}

#############
## SUBNETS ##
#############

resource "azurerm_subnet" "application" {

  resource_group_name  = azurerm_resource_group.velozient_resource_group.name

  name                 = var.subnet_app
  virtual_network_name = azurerm_virtual_network.vnet_01.name
  address_prefixes     = var.cidr_app

}

resource "azurerm_subnet" "web" {

  resource_group_name  = azurerm_resource_group.velozient_resource_group.name

  name                 = var.subnet_web
  virtual_network_name = azurerm_virtual_network.vnet_01.name
  address_prefixes     = var.cidr_web

}

resource "azurerm_subnet" "database" {

  resource_group_name  = azurerm_resource_group.velozient_resource_group.name

  name                 = var.subnet_db
  virtual_network_name = azurerm_virtual_network.vnet_01.name
  address_prefixes     = var.cidr_db

}