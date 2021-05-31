data "aws_eip" "openvpn" {
  public_ip = var.public_ip
  count     = var.public_ip != "" ? 1 : 0
}
# CREATE ELASTIC IP ADDRESS
resource "aws_eip" "openvpn" {
  count             = var.public_ip != "" ? 0 : 1
  instance          = aws_instance.openvpn.id
  vpc               = true
}
locals {
  public_ip     = var.public_ip != "" ? join("", data.aws_eip.openvpn.*.public_ip) : join("", aws_eip.openvpn.*.public_ip)
  allocation_id = var.public_ip != "" ? join("", data.aws_eip.openvpn.*.id) : join("", aws_eip.openvpn.*.id)
}
# ASSIGN ELASTIC IP ADDRESS
resource "aws_eip_association" "openvpn" {
  instance_id   = aws_instance.openvpn.id
  allocation_id = local.allocation_id
}

