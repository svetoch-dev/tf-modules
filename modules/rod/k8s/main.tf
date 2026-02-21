provider "kubernetes" {
  host                   = var.k8s_api.endpoint
  token                  = var.k8s_api.token
  cluster_ca_certificate = var.k8s_api.ca_cert
}

module "k8s" {
  source     = "../../k8s"
  rbac       = local.rbac_merged
  namespaces = local.namespaces_merged
}
