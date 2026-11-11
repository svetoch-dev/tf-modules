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
        app_runner = {
          name      = "app-runner-infra-write"
          read_only = false
          create    = true
        }
      }
      secrets = {
      }
    }
  }
}
