resource vault_mount "default_pki" {
  path = "default_pki"
  type = "pki"
}

resource vault_pki_secret_backend_root_cert "ca" {
  backend = vault_mount.default_pki.path

  type = "internal"
  common_name = "http://scb-vault.yulei.aws.hashidemos.io/"
  ttl = "315360000"
  format = "pem"
  private_key_format = "der"
  key_type = "rsa"
  key_bits = 4096
  exclude_cn_from_sans = true
  ou = "security services"
  organization = "Standard Chartered Bank"
}


resource vault_pki_secret_backend_config_urls "ca_config_urls" {
  backend              = vault_mount.default_pki.path
  issuing_certificates = [
    "${var.vault_url}/v1/default_pki/ca",

  ]
}

resource vault_pki_secret_backend_role "nginx" {
  backend = vault_mount.default_pki.path
  name    = "nginx"
  allow_subdomains = true
  allow_any_name = true
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
  ]
  ttl = "30000"
  max_ttl = "180000"
}

