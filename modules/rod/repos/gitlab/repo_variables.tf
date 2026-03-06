locals {
  repos = {
    infrastructure = {
      name = var.repo.name
      org  = var.repo.group
      deploy_keys = {
        argocd = {
          name      = "argocd"
          read_only = true
          create    = true
        }
      }
      secrets = {
      }
    }
  }
}
