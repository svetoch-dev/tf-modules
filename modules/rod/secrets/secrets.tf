locals {
  secrets = merge(
    var.env.short_name == "int" ? local.argocd-clusters : {},
    var.env.short_name == "int" ? local.argocd-repos : {},
    local.import_secrets,
  )
}
