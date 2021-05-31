data "aws_route53_zone" "_" {
  name         = "" #pass in name
  private_zone = false
}


resource "random_string" "password" {
  length  = 16
  upper   = true
  lower   = true
  number  = true
  special = true

  keepers = {
    env = "${terraform.workspace}"
  }
}

module "openvpn" {
  source                         = "./modules/openvpn"
  network_vpc_id                 = var.network_vpc_id
  openvpn_ami                    = var.ami
  openvpn_key_name               = var.openvpn_key_name
  openvpn_subnet_id              = var.subnet_id
  openvpn_route53_public_zone_id = data.aws_route53_zone._.id
  openvpn_public_dns             = var.openvpn_public_dns
  openvpn_public_hostname        = var.openvpn_public_hostname
  openvpn_admin_pswd             = random_string.password.result
  openvpn_license                = var.openvpn_license
  openvpn_reroute_dns            = 1
  openvpn_all_access             = var.openvpn_all_access
  openvpn_ssh_access             = var.openvpn_ssh_access
  custom_security_groups         = var.custom_security_groups
  public_ip                      = ""
}