data "google_client_config" "provider" {}

data "yandex_client_config" "client" {}


module "k8s" {
  source     = "../../k8s"
  k8s_api    = var.k8s_api
  rbac       = local.rbac
  namespaces = local.namespaces
}
