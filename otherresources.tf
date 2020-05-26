
resource "github_repository" "cba-vault-namespace-nsproject1" {
  name        = "cba-vault-namespace-nsproject1"
  description = "My awesome codebase"

  private = true

  template {
    owner = "ausmartway"
    repository = "vault-namespace-template"
  }
}

resource "tfe_workspace" "project1-workspace" {
  name         = "project1-workspace"
  organization = "yulei"
  vcs_repo  {
   identifier = github_repository.cba-vault-namespace-nsproject1.full_name
    oauth_token_id = "ot-jVjGUxW5YamZeVSZ"
  }
}

resource "tfe_variable" "project1-workspace-namespace-vault-namespace" {
  workspace_id=tfe_workspace.project1-workspace.id
  description="namespace this workspace is bind to"
  category="env"
  key="VAULT_NAMESPACE"
  value=vault_namespace.project1-namespace.path
}

// resource "vault_namespace" "project1-namespace" {
//   path = "project1"
// }


// resource "vault_policy" "project1-namespace-admin-policy" {
//   name="project1-namespace-admin-policy"
//   policy=<<EOP
// # Manage namespaces
// path "sys/namespaces/*" {
//    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
// }

// # Manage policies
// path "sys/policies/acl/*" {
//    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
// }

// # List policies
// path "sys/policies/acl" {
//    capabilities = ["list"]
// }

// # Enable and manage secrets engines
// path "sys/mounts/*" {
//    capabilities = ["create", "read", "update", "delete", "list"]
// }

// # List available secrets engines
// path "sys/mounts" {
//   capabilities = [ "read" ]
// }

// # Create and manage entities and groups
// path "identity/*" {
//    capabilities = ["create", "read", "update", "delete", "list"]
// }

// # Manage tokens
// path "auth/token/*" {
//    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
// }

// # Manage secrets at 'kv'
// path "kv/*" {
//    capabilities = ["create", "read", "update", "delete", "list"]
// }
// EOP

// }

// resource "vault_token" "project1-namespace-admin-token" {
//   policies = ["default",vault_policy.project1-namespace-admin-policy.name]
//   renewable = true
//   ttl = "96h"
//   renew_min_lease = 43200
//   renew_increment = 86400
// }

// resource "tfe_variable" "project1-workspace-namespace-vault-token" {
//   workspace_id=tfe_workspace.project1-workspace.id
//   description="Admin Vault Token "
//   category="env"
//   key="VAULT_TOKEN"
//   value=vault_token.project1-namespace-admin-token.client_token
// }

// resouce "vault_identity_entity" "project1-namespace-admin-identity-entity" {
//   name="project1-namespace-admin-identity-entity"

// }
// resource "vault_entity_group" "project1-namespace-admin-group" {
//   name="project1-namespace-admin-group"

// }

