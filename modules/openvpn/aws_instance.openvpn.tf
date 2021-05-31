# CREATE OPENVPN ACCESS SERVER INSTANCE
resource "aws_instance" "openvpn" {
  ami                  = var.openvpn_ami
  instance_type        = var.openvpn_instance_size
  key_name             = var.openvpn_key_name
  subnet_id            = var.openvpn_subnet_id
  iam_instance_profile = aws_iam_instance_profile.openvpn.name
  user_data            = data.template_file.user_data.rendered

  vpc_security_group_ids = [aws_security_group.openvpn.id]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "OpenVPN Access Server"
    Environment = lower(terraform.workspace) #lacuna-prod
    Stack       = lower(var.stack_name)
  }
}

# USER DATA TEMPLATE TO PRE-CONFIGURE THE OPENVPN ACCESS SERVER
data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")

  vars = {
    public_hostname = var.openvpn_public_hostname
    admin_user      = var.openvpn_admin_user
    admin_pswd      = var.openvpn_admin_pswd
    license_key     = var.openvpn_license
    reroute_gw      = var.openvpn_reroute_gw
    reroute_dns     = var.openvpn_reroute_dns
  }
}
