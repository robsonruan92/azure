# load balance #

variable "lb_name_public_ip" {
    default = "web-lb-public-ip"
}

variable "web_lb_name" {
    default = "web-lb"
}

variable "web_backend_lb_name" {
    default = "web-lb-backend"
}

variable "web_lb_probe_name" {
    default = "http-probe"
}

variable "web_lb_rule_name" {
    default = "http-rule"
}