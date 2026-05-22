locals {
  rbac = {
    service_accounts = {
      argocd = {
        namespace = "argocd"
        name      = "argocd"
      }
      runner = {
        namespace = "${var.ci.type}-runner"
        name      = "runner"
      }
      runner-app = {
        namespace = "${var.ci.type}-runner-app"
        name      = "runner-app"
      }
    }
  }
}
