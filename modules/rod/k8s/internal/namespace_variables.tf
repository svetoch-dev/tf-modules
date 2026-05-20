locals {
  namespaces = {
    argocd = {
      name = "argocd"
    }
    grafana = {
      name = "grafana"
    }
    "${var.ci.type}-runner" = {
      name = "${var.ci.type}-runner"
    }
    "${var.ci.type}-runner-app" = {
      name = "${var.ci.type}-runner-app"
    }
    gha-operator = var.ci.type == "gha" ? {
      name = "gha-operator"
    } : null
  }
}
