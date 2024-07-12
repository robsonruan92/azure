######################
## VMs CONFIGURATION ##
######################

resource "azurerm_virtual_machine" "web_vm" {

  resource_group_name               = azurerm_resource_group.velozient_resource_group.name
  location                          = azurerm_resource_group.velozient_resource_group.location

  name                              = "var.web_vm_name"
  count                             = 2
  network_interface_ids             = [azurerm_network_interface.web_inet[count.index].id]
  vm_size                           = var.web_vms_size

  storage_image_reference {
    publisher                       = "Canonical"
    offer                           = "UbuntuServer"
    sku                             = "18.04-LTS"
    version                         = "latest"
  }

  storage_os_disk {
    name                            = "disk-${var.web_vm_name}"
    caching                         = "ReadWrite"
    create_option                   = "FromImage"
    managed_disk_type               = "Standard_LRS"
  }

  os_profile {
    computer_name                   = "os-${var.web_vm_name}"
    admin_username                  = var.vm_admin_username
    admin_password                  = var.vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "app_vm" {
  
  resource_group_name               = azurerm_resource_group.velozient_resource_group.name
  location                          = azurerm_resource_group.velozient_resource_group.location

  name                              = var.app_vm_name
  network_interface_ids             = [azurerm_network_interface.app_inet.id]
  vm_size                           = var.app_vms_size

  storage_image_reference {
    publisher                       = "Canonical"
    offer                           = "UbuntuServer"
    sku                             = "18.04-LTS"
    version                         = "latest"
  }

  storage_os_disk {
    name                            = "disk-${var.app_vm_name}"
    caching                         = "ReadWrite"
    create_option                   = "FromImage"
    managed_disk_type               = "Standard_LRS"
  }

  os_profile {
    computer_name                   = "os-${var.app_vm_name}"
    admin_username                  = var.vm_admin_username
    admin_password                  = var.vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}

########################
## NETWORK INTERFACES ##
########################

resource "azurerm_network_interface" "web_inet" {

  resource_group_name               = azurerm_resource_group.velozient_resource_group.name
  location                          = azurerm_resource_group.velozient_resource_group.location
  
  name                              = var.web_inet_name
  count                             = 2

  ip_configuration {
    name                            = "internal"
    subnet_id                       = azurerm_subnet.web.id
    private_ip_address_allocation   = "Dynamic"
  }

  tags = var.tags

}

resource "azurerm_network_interface" "app_inet" {

  resource_group_name               = azurerm_resource_group.velozient_resource_group.name
  location                          = azurerm_resource_group.velozient_resource_group.location

  name                              = var.app_inet_name

  ip_configuration {
    name                            = "internal"
    subnet_id                       = azurerm_subnet.application.id
    private_ip_address_allocation   = "Dynamic"
  }

  tags = var.tags

}