resource "vault_namespace" "nsproject1" {
  path = "nsproject1"
}

resource "vault_namespace" "nsproject2" {
  path = "nsproject2"
}

// resource "github_repository" "cba-vault-namespace-nsproject1" {
//   name        = "cba-vault-namespace-nsproject1"
//   description = "My awesome codebase"

//   private = true

//   // template {
//   //   owner = "ausmartway"
//   //   repository = "vault-namespace-template"
//   // }
// }