terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "customer-demo-yulei-management-org"

    workspaces {
      name = "vault-super-admin"
    }
  }
}