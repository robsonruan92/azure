#######################
## NETWORK VARIABLES ##
#######################

# subnets #

variable "subnet_app" {
  default = "subnet-application"
}

variable "subnet_web" {
  default = "subnet-web"
}

variable "subnet_db" {
  default = "subnet-db"
}

# vnet #

variable "vnet_name" {
  default = "vnet-01"
}

# cidr blocks #

variable "cidr_vnet_01" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "cidr_app" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "cidr_web" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "cidr_db" {
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

# network security group #

variable "name_nsg_app" {
  default = "nsg-app"
}

variable "name_nsg_web" {
  default = "nsg-web"
}

variable "name_nsg_db" {
  default = "nsg-db"
}

# vm network interface #

variable "web_inet_name" {
  default = "web_inet"
}

variable "app_inet_name" {
  default = "app_inet"
}