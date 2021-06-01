# SECURITY GROUP FOR OPENVPN ACCESS SERVER
resource "aws_security_group" "openvpn" {
  name        = "${terraform.workspace}_public_vpn"
  description = "${upper(terraform.workspace)} Public VPN Security Rules"
  vpc_id      = var.network_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.openvpn_all_access
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.openvpn_ssh_access
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.openvpn_https_access
  }

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = var.openvpn_admin_access
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = var.openvpn_udp_access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${lower(terraform.workspace)}_${lower(var.stack_name)}"
    Environment = ""
    Stack       = lower(var.stack_name)
  }
}
