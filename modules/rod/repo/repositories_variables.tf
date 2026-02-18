locals {
  repositories = {
    infrastructure = {
      name = "infrastructure"
      org  = var.ci.group
      deploy_keys = {
        argocd = {
          name      = "argocd_test"
          read_only = true
          create    = true
        }
      }
    }
  }
}
