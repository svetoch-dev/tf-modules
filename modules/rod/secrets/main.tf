provider "kubernetes" {
  host                   = var.k8s_api.endpoint
  token                  = var.k8s_api.token
  cluster_ca_certificate = var.k8s_api.ca_cert
}

module "secrets" {
  source  = "../../secrets"
  secrets = local.secrets_merged
}
