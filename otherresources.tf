resource "vault_namespace" "nsproject1" {
  path = "nsproject1"
}

// resource "vault_namespace" "nsproject2" {
//   path = "nsproject2"
// }

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
    identifier = "cba-demo/cba-vault-namespace-nsproject1"
    // identifier = "cba-demo/${github_repository.cba-vault-namespace-nsproject1.name}"
    oauth_token_id = "ot-tkpMwbbMB59jSYiE"
  }
}