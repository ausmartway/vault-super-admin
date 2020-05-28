output "vault_token" {
    value = vault_token.project1-namespace-admin-token.client_token
}

output "github_repo_url" {
    value = "Your github url is: ${github_repository.cba-vault-namespace-nsproject1.http_clone_url}"
}

output "github_repo_full_name" {
    value = "github_repository.cba-vault-namespace-nsproject1.full_name"
}

output "tfe_worksapce_id" {
    value=tfe_workspace.project1-workspace.id
}


output "vault_namespace_path" {
    value=vault_namespace.project1-namespace.path
}

