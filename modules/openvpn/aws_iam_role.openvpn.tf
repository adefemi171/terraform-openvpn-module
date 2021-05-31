# IAM Role for OpenVPN
resource "aws_iam_role" "openvpn" {
  name = "${terraform.workspace}-openvpn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# IAM Instance Profile for OpenVPN
resource "aws_iam_instance_profile" "openvpn" {
  name = "${terraform.workspace}-openvpn"
  role = aws_iam_role.openvpn.name
}
