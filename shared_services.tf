//pki root CA secret engine
resource "vault_mount" "pki_root" {
  path                      = "pki_root"
  type                      = "pki"
  default_lease_ttl_seconds = 3600 * 24 * 31 * 13     //13 Months
  max_lease_ttl_seconds     = 3600 * 24 * 31 * 12 * 3 //3 Years
}

resource "vault_pki_secret_backend_root_cert" "self-signing-cert" {
  backend              = vault_mount.pki_root.path
  type                 = "internal"
  common_name          = "Root CA"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  ou                   = "APJ SE"
  organization         = "Hashicorp Demo Org"
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki_root.path
  issuing_certificates    = ["${var.vault_address}/v1/${vault_mount.pki_root.path}/ca"]
  crl_distribution_points = ["${var.vault_address}/v1/${vault_mount.pki_root.path}/crl"]
}

//pki intermediate CA secret engine
resource "vault_mount" "pki_intermediate" {
  depends_on                = [vault_pki_secret_backend_root_cert.self-signing-cert]
  path                      = "pki_intermediate"
  type                      = "pki"
  default_lease_ttl_seconds = 2678400  //31 days
  max_lease_ttl_seconds     = 24819200 //13 Months
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  depends_on  = [vault_pki_secret_backend_root_cert.self-signing-cert]
  backend     = vault_mount.pki_intermediate.path
  type        = "internal"
  common_name = "apj-ca.hashicorp.demo"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "root" {
  depends_on           = [vault_pki_secret_backend_root_cert.self-signing-cert, vault_pki_secret_backend_root_cert.self-signing-cert]
  backend              = vault_mount.pki_root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  ttl                  = 3600 * 24 * 31 * 12 * 2 //2 Years
  common_name          = "apj-ca.hashicorp.demo"
  exclude_cn_from_sans = true
  ou                   = "APJ SE"
  organization         = "Hashicorp Demo Org"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.pki_intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.root.certificate
}

resource "vault_pki_secret_backend_config_urls" "config_urls_int" {
  backend                 = vault_mount.pki_intermediate.path
  issuing_certificates    = ["${var.vault_address}/v1/${vault_mount.pki_intermediate.path}/ca"]
  crl_distribution_points = ["${var.vault_address}/v1/${vault_mount.pki_intermediate.path}/crl"]
}


// a few PKI roles that applications can use
resource "vault_pki_secret_backend_role" "dev-vm-app-servers" {
  backend         = vault_mount.pki_intermediate.path
  name            = "dev-vm-app-servers"
  ttl             = 3600 * 24 * 31 * 1 //1 Months
  max_ttl         = 3600 * 24 * 31 * 2 //2 Months
  allow_localhost = false
  allowed_domains = ["dev.hashicorp.demo"]
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  allow_bare_domains = false
  allow_subdomains   = true
  allow_any_name     = false
  allow_ip_sans      = false
  require_cn         = true
}

resource "vault_pki_secret_backend_role" "cyberark-login-cert" {
  backend         = vault_mount.pki_intermediate.path
  name            = "cyberark-login-cert"
  ttl             = 3600 * 24 * 31 * 1 //1 Months
  max_ttl         = 3600 * 24 * 31 * 2 //2 Months
  allow_localhost = false
  allowed_domains = ["dev.hashicorp.demo"]
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  allow_bare_domains = false
  allow_subdomains   = true
  allow_any_name     = false
  allow_ip_sans      = false
  require_cn         = true
}


resource "vault_pki_secret_backend_role" "dev-docker-app-servers" {
  backend         = vault_mount.pki_intermediate.path
  name            = "dev-docker-app-servers"
  ttl             = 3600 * 24 * 3 //3 days
  max_ttl         = 3600 * 24 * 7 //7 days
  allow_localhost = false
  allowed_domains = ["dev.hashicorp.demo"]
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  allow_bare_domains = false
  allow_subdomains   = true
  allow_any_name     = false
  allow_ip_sans      = false
  require_cn         = true
}

resource "vault_pki_secret_backend_role" "prod-vm-app-servers" {
  backend         = vault_mount.pki_intermediate.path
  name            = "prod-vm-app-servers"
  ttl             = 3600 * 24 * 31 * 1 //6 Months
  max_ttl         = 3600 * 24 * 31 * 2 //12 Months
  allow_localhost = false
  allowed_domains = ["prod.hashicorp.demo"]
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  allow_bare_domains = false
  allow_subdomains   = true
  allow_any_name     = false
  allow_ip_sans      = false
  require_cn         = true
}

resource "vault_pki_secret_backend_role" "vault-servers" {
  backend         = vault_mount.pki_intermediate.path
  name            = "vault-servers"
  ttl             = 3600 * 24 * 31 * 13 //13 Months
  max_ttl         = 3600 * 24 * 31 * 13 //13 Months
  allow_localhost = false
  allowed_domains = ["*"]
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  allow_bare_domains = false
  allow_subdomains   = true
  allow_any_name     = true
  allow_ip_sans      = false
  require_cn         = true
}



resource "vault_pki_secret_backend_role" "prod-docker-app-servers" {
  backend         = vault_mount.pki_intermediate.path
  name            = "prod-docker-app-servers"
  ttl             = 3600 * 24 * 7 * 2 //2 weeks
  max_ttl         = 3600 * 24 * 7 * 4 //4 weeks
  allow_localhost = false
  allowed_domains = ["prod.hashicorp.demo"]
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
  allow_bare_domains = false
  allow_subdomains   = true
  allow_any_name     = false
  allow_ip_sans      = false
  require_cn         = true
}


//transit secret engine
resource "vault_mount" "encryption-as-a-service" {
  path                      = "EaaS"
  type                      = "transit"
  description               = "Encryption/Decryption as a Service for MGL"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_transit_secret_backend_key" "Internetbanking" {
  backend = vault_mount.airstarthencryption.path
  name    = "Internetbanking"
  deletion_allowed = true
  exportable=false
  allow_plaintext_backup = true
}

