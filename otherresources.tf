resource "vault_namespace" "project1-namespace" {
  path = "project1"
}

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

resource "tfe_variable" "project1-workspace-namespace-vault-token" {
  workspace_id=tfe_workspace.project1-workspace.id
  description="namespace this workspace is bind to"
  category="env"
  key="VAULT_NAMESPACE"
  value=vault_namespace.project1-namespace.path
}

resource "vault_policy" "project1-namespace-admin-policy" {
  name="project1-namespace-admin-policy"
  policy=<<EOP
# Manage namespaces
path "${vault_namespace.project1-namespace.path}/sys/namespaces/*" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage policies
path "${vault_namespace.project1-namespace.path}/sys/policies/acl/*" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List policies
path "${vault_namespace.project1-namespace.path}/sys/policies/acl" {
   capabilities = ["list"]
}

# Enable and manage secrets engines
path "${vault_namespace.project1-namespace.path}/sys/mounts/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

# List available secrets engines
path "${vault_namespace.project1-namespace.path}/sys/mounts" {
  capabilities = [ "read" ]
}

# Create and manage entities and groups
path "${vault_namespace.project1-namespace.path}/identity/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage tokens
path "${vault_namespace.project1-namespace.path}/auth/token/*" {
   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOP

}

resource "vault_token" "project1-namespace-admin-token" {
  policies = [vault_policy.project1-namespace-admin-policy.name]
  renewable = true
  ttl = "24h"
  renew_min_lease = 43200
  renew_increment = 86400
}