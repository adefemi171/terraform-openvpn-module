terraform {
  backend "s3" {
    bucket               = ""
    key                  = "terraform/state/apps/staging/openvpn.tf"
    workspace_key_prefix = "terraform"
    region               = "us-west-2"
  }
}