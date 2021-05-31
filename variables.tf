variable "region" {
  type    = string
  default = ""
}

variable "profile" {
  type    = string
  default = ""
}

variable "ami" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "network_vpc_id" {
  type = string
  default = ""
}

variable "custom_security_groups" {
  type    = list(any)
  default = ["", ]
}

variable "openvpn_all_access" {
  type    = list(any)
  default = ["", ]
}

variable "openvpn_ssh_access" {
  type    = list(any)
  default = ["", ]
}

variable "openvpn_public_dns" {
  type = string
  default = ""
}

variable "openvpn_public_hostname" {
  type = string
  default = ""
}

variable "openvpn_key_name" {
  type = string
  default = ""
}

variable "openvpn_license" {
  type    = string
  default = ""
}

