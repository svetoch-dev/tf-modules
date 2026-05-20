module "k8s" {
  source     = "../../k8s"
  rbac       = local.rbac_merged
  namespaces = local.namespaces_merged
}
