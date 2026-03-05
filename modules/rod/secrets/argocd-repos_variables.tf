locals {
  argocd-repos = {
    for repo_name, repo_obj in var.argocd_repos :
    repo_name => {
      name = "argocd-${repo_obj.org}-${repo_name}"
      secrets_data = {
        type          = "git"
        url           = repo_obj.ssh_url
        sshPrivateKey = repo_obj.private_key_openssh
      }
      k8s = {
        enabled   = true
        namespace = "argocd"
      }
      annotations = {
      }
      labels = {
        "argocd.argoproj.io/secret-type" = "repository"
      }
    }
  }
}
