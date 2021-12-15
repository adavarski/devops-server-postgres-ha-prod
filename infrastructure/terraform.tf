terraform {
  backend "http" {
     skip_cert_verification = true
  }
}

provider "hcloud" {
  token   = var.hcloud_token
}

