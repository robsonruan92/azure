#########
## NSG ##
#########

resource "azurerm_network_security_group" "app_nsg" {

  resource_group_name   = azurerm_resource_group.velozient_resource_group.name
  location              = azurerm_resource_group.velozient_resource_group.location

  name                  = var.name_nsg_app

  security_rule {
    name                       = "Allow-Internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "10.0.0.0/16"
  }
  
  tags = var.tags

}

resource "azurerm_network_security_group" "web_nsg" {
  
  resource_group_name   = azurerm_resource_group.velozient_resource_group.name
  location              = azurerm_resource_group.velozient_resource_group.location

  name                  = var.name_nsg_web

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = var.tags

}

resource "azurerm_network_security_group" "db_nsg" {

  resource_group_name   = azurerm_resource_group.velozient_resource_group.name
  location              = azurerm_resource_group.velozient_resource_group.location

  name                  = var.name_nsg_db

  security_rule {
    name                       = "Allow-DB-Access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  tags = var.tags
  
}


#####################
## NSG ASSOCIATION ##
#####################

resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  
  subnet_id                 = azurerm_subnet.application.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id

}

resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
  
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id

}

resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {

  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id

}
