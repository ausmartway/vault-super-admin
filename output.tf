output "vault_token" {
    value = vault_token.project1-namespace-admin-token.client_token
}

output "github_repo_url" {
    vaule = "Your github url is: ${github_repository.cba-vault-namespace-nsproject1.http_clone_url}"
}
