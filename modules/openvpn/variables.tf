variable "network_vpc_id" {
  type = string
}

variable "stack_name" {
  default = "openvpn"
}

variable "openvpn_ami" {
  type = string
}

variable "openvpn_instance_size" {
  default = "t2.micro"
  type    = string
}

variable "openvpn_key_name" {
  type = string
}

variable "openvpn_subnet_id" {
  type = string
}

variable "openvpn_route53_public_zone_id" {
  type = string
}

variable "openvpn_public_dns" {
  type = string
  default = ""
}

variable "openvpn_public_hostname" {
  type = string
}

variable "openvpn_admin_user" {
  type    = string
  default = "openvpn"
}

variable "openvpn_admin_pswd" {
  type = string
}

variable "openvpn_license" {
  type    = string
  default = ""
}

variable "openvpn_reroute_gw" {
  default = 0
}

variable "openvpn_reroute_dns" {
  default = 0
}

variable "custom_security_groups" {
  type    = list(any)
  default = []
}


variable "openvpn_all_access" {
  type = list(any)
}


variable "openvpn_ssh_access" {
  type = list(any)
}


variable "openvpn_https_access" {
  type = list(any)
  default = [
    "0.0.0.0/0",
  ]
}


variable "openvpn_admin_access" {
  type = list(any)
  default = [
    "0.0.0.0/0",
  ]
}

# WHITELIST CIDR_BLOCK(s) FOR UDP TRAFFIC (UDP 1194)
# (e.g. Public Network)
variable "openvpn_udp_access" {
  type = list(any)
  default = [
    "0.0.0.0/0",
  ]
}

variable "public_ip" {
  default     = ""
  type        = string
  description = "To use preallocated static IP address, please set variable to existing EIP. If it's empty, it will be created dynamically."
}


