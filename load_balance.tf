##################
## LOAD BALANCE ##
##################

resource "azurerm_public_ip" "web_lb" {

  resource_group_name     = azurerm_resource_group.velozient_resource_group.name
  location                = azurerm_resource_group.velozient_resource_group.location
  
  name                    = var.lb_name_public_ip
  allocation_method       = "Dynamic"

  tags = var.tags

}

resource "azurerm_lb" "web_lb" {

  location                = azurerm_resource_group.velozient_resource_group.location
  resource_group_name     = azurerm_resource_group.velozient_resource_group.name

  name                    = var.web_lb_name

  frontend_ip_configuration {
    name                  = "public-ip"
    public_ip_address_id  = azurerm_public_ip.web_lb.id
  }
  
  tags = var.tags
  
}

resource "azurerm_lb_backend_address_pool" "web_lb_backend" {

  name                = var.web_backend_lb_name
  loadbalancer_id     = azurerm_lb.web_lb.id

}

resource "azurerm_lb_probe" "web_lb_probe" {

  name                = var.web_lb_probe_name
  loadbalancer_id     = azurerm_lb.web_lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"

}

resource "azurerm_lb_rule" "web_lb_rule" {

  name                           = var.web_lb_rule_name
  loadbalancer_id                = azurerm_lb.web_lb.id
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80

}


