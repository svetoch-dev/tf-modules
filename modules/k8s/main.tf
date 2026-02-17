provider "kubernetes" {
  host                   = var.k8s_api.endpoint
  token                  = var.k8s_api.token
  cluster_ca_certificate = var.k8s_api.ca_cert
}

module "namespaces" {
  source     = "./namespaces"
  namespaces = var.namespaces
  providers = {
    kubernetes = kubernetes
  }
}

module "rbac" {
  source                      = "./rbac"
  custom_service_accounts     = var.rbac.service_accounts
  custom_cluster_roles        = var.rbac.cluster_roles
  custom_cluster_role_binding = var.rbac.cluster_role_binding
  custom_roles                = var.rbac.roles
  custom_role_binding         = var.rbac.role_binding
  depends_on = [
    module.namespaces,
  ]
  providers = {
    kubernetes = kubernetes
  }
}

module "services" {
  source   = "./services"
  external = var.services.external
  depends_on = [
    module.namespaces,
  ]
  providers = {
    kubernetes = kubernetes
  }
}
