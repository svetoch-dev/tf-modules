locals {
  secrets = merge(
    local.argocd-clusters,
    local.argocd-repos,
    local.import_secrets,
  )
}
