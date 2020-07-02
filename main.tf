
#github repo
resource "github_repository" "scb-vault-namespace-nsprototype1" {
  name        = "scb-vault-namespace-nsprototype1"
  description = "Terraform for Vault code repository for Vault Namespace prototype1."

  private = true

  template {
    owner = "ausmartway"
    repository = "vault-namespace-template"
  }
}

# Vault namespace,policy and admin token for namespaces
resource "vault_namespace" "prototype1-namespace" {
  path = "prototype1"
}


resource "vault_policy" "prototype1-namespace-admin-policy" {
  name="prototype1-namespace-admin-policy"
  policy=<<EOP
# Manage namespaces
path "${vault_namespace.prototype1-namespace.path}/sys/namespaces/*" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage policies
path "${vault_namespace.prototype1-namespace.path}/sys/policies/acl/*" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List policies
path "${vault_namespace.prototype1-namespace.path}/sys/policies/acl" {
   capabilities = ["list"]
}

# Enable and manage secrets engines
path "${vault_namespace.prototype1-namespace.path}/sys/mounts/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

# List available secrets engines
path "${vault_namespace.prototype1-namespace.path}/sys/mounts" {
  capabilities = [ "read" ]
}

# Create and manage entities and groups
path "${vault_namespace.prototype1-namespace.path}/identity/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage tokens
path "${vault_namespace.prototype1-namespace.path}/auth/token/*" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets at '*'
path "${vault_namespace.prototype1-namespace.path}/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}
EOP

}

resource "vault_token" "prototype1-namespace-admin-token" {
  policies = ["default",vault_policy.prototype1-namespace-admin-policy.name]
  renewable = true
  no_parent=true
  ttl = "96h"
  renew_min_lease = 43200
  renew_increment = 86400
}

#TFE workspace and variable
resource "tfe_workspace" "prototype1-workspace" {
  name         = "prototype1-workspace"
  organization = var.tfe-organization
  vcs_repo  {
   identifier = github_repository.scb-vault-namespace-nsprototype1.full_name
    oauth_token_id = var.oauth-token-id
  }
}

resource "tfe_variable" "prototype1-workspace-namespace-vault-namespace" {
  workspace_id=tfe_workspace.prototype1-workspace.id
  description="namespace this workspace is bind to"
  category="env"
  key="VAULT_NAMESPACE"
  value=vault_namespace.prototype1-namespace.path
}

resource "tfe_variable" "prototype1-workspace-namespace-vault-token" {
  workspace_id=tfe_workspace.prototype1-workspace.id
  description="The admin VAULT_TOKEN for this namespace"
  category="env"
  key="VAULT_TOKEN"
  value=vault_token.prototype1-namespace-admin-token.client_token
  sensitive=true
}

// // //--------------------------------------------------------------------
// // // Variables




// //--------------------------------------------------------------------
// // Modules
// module "github_repo_module" {
//   source  = "app.terraform.io/customer-demo-yulei-management-org/github-repo-module/specialcustomer"
//   version = "0.0.3"

//   reponame = "repositoryfor-${module.vault_namespace_module.vault-namespace}"
// }

// module "tfe_vault_workspace_module" {
//   source  = "app.terraform.io/customer-demo-yulei-management-org/tfe-vault-workspace-module/specialcustomer"
//   version = "0.0.4"

//   github-repo-fullname = "${module.github_repo_module.repoidentifier}"
//   oauth-token-id = "ot-Xsx6ReJAouFcMzYN"
//   tfe-organization = "customer-demo-yulei-consumer-org"
//   tfe-workspace-name = "workspacefor-${module.vault_namespace_module.vault-namespace}"
//   vault-namespace = "${module.vault_namespace_module.vault-namespace}"
//   vault-token = "${module.vault_namespace_module.vault-token}"
// }

// module "vault_namespace_module" {
//   source  = "app.terraform.io/customer-demo-yulei-management-org/vault-namespace-module/specialcustomer"
//   version = "0.0.2"

//   namespace = "namespaceforscb"
// }

// //--------------------------------------------------------------------
// // Modules
// module "vault_namespace_selfservice_module" {
//   source  = "app.terraform.io/customer-demo-yulei-management-org/vault-namespace-selfservice-module/specialcustomer"
//   version = "0.0.2"

//   namespace-name = "retailbanking"
// }


// // Modules
// module "vault_namespace_businessbanking_module" {
//   source  = "app.terraform.io/customer-demo-yulei-management-org/vault-namespace-selfservice-module/specialcustomer"
//   version = "0.0.2"

//   namespace-name = "businessbanking"
// }

// //--------------------------------------------------------------------
// // Modules
// module "vault_namespace_selfservice_module_investmentbanking" {
//   source  = "app.terraform.io/customer-demo-yulei-management-org/vault-namespace-selfservice-module/specialcustomer"
//   version = "0.0.5"

//   namespace-name = "investmentbanking"
// }