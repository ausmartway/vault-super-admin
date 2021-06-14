variable "tfe-organization" {
  description = "Name of the Terraform Enterprise organization"
  default     = "customer-demo-yulei-consumer-org"
}

variable "oauth-token-id" {
  description = "oAuth token id from TFE organization"
  default     = "ot-Xsx6ReJAouFcMzYN"
}

variable "vault_url" {
  description = "URL of vault"
}
