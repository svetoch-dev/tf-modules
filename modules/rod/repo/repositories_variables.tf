locals {
  repositories = {
    infrastructure1 = {
      name = "infrastructure1"
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
