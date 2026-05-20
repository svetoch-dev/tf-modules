module "namespaces" {
  source     = "./namespaces"
  namespaces = var.namespaces
}

module "rbac" {
  source               = "./rbac"
  service_accounts     = var.rbac.service_accounts
  cluster_roles        = var.rbac.cluster_roles
  cluster_role_binding = var.rbac.cluster_role_binding
  roles                = var.rbac.roles
  role_binding         = var.rbac.role_binding
  depends_on = [
    module.namespaces,
  ]
}

module "services" {
  source   = "./services"
  external = var.services.external
  depends_on = [
    module.namespaces,
  ]
}
