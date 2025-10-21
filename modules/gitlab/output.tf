output "repositories" {
  description = "gitlab repositories"
  sensitive   = true
  value = {
    for repo_name, repo_obj in var.repositories :
    repo_name => {
      ssh_url  = format("git@%s:%s/%s", var.domain, repo_obj.org, repo_obj.name)
      http_url = format("https://%s/%s/%s", var.domain, repo_obj.org, repo_obj.name)
      org      = repo_obj.org
      deploy_keys = {
        for key_name, key_obj in repo_obj.deploy_keys :
        key_name => {
          public_key_openssh  = key_obj.public_key != "" ? key_obj.public_key : tls_private_key.deploy_keys["${repo_name}@${key_name}"].public_key_openssh
          private_key_openssh = key_obj.private_key != "" ? key_obj.private_key : tls_private_key.deploy_keys["${repo_name}@${key_name}"].private_key_openssh
        }
      }
    }
  }
}
