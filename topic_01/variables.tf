variable "region" {
  default = "Brazil South"
}

# vm (web & application) # 

variable "app_vm_name" {
  default = "app-vm"
}

variable "web_vm_name" {
  default = "web-vm"
}

variable "web_vms_size" {
  default = "Standard_B1s"
}

variable "app_vms_size" {
  default = "Standard_B1s"
}

variable "vm_admin_username" {
  type        = string
  default     = "adminuser"
}

variable "vm_admin_password" {
  default     = "#Change_This_DB_Password_1234!"
  sensitive   = true
}

# azure sql (server & database) #

variable "mssql_admin_username" {
  type        = string
  default     = "sqladmin"
}

variable "mssql_admin_password" {
  default     = "#Change_This_DB_Password_1234!"
  sensitive   = true
}

variable "mssql_server_version" {
  default = "12.0"
}

variable "mssql_db_edition" {
  default = "Standard"
}

variable "mssql_db_collation" {
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "mssql_license_type" {
  default = "BasePrice"
}

variable "mssql_sku_name" {
  default = "Basic"
}

variable "tags" {
  default = {
    Environment = "Production"
    Description = "Velozient"
  }
}