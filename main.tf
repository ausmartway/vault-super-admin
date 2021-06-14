// ## --------------------------------------------------------------------
// ## Modules
//  module "vault_namespace_selfservice_module_hashstalks" {
//     source  = "app.terraform.io/customer-demo-yulei-management-org/vault-namespace-selfservice-module/specialcustomer"
//     version = "0.0.10"
//     namespace-name = "hashstalks"
//     vault-addr=var.vault_url
//   }

// output "module_vault_namespace_selfservice_module_hashstalks_results" {
//   value = module.vault_namespace_selfservice_module_hashstalks.results
// }

## --------------------------------------------------------------------
## Modules
 module "vault_namespace_selfservice_module_anzse" {
    source  = "app.terraform.io/customer-demo-yulei-management-org/vault-namespace-selfservice-module/specialcustomer"
    version = "0.0.10"
    namespace-name = "anzse"
    vault-addr=var.vault_url
  }


