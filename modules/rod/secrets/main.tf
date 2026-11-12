module "rod_secrets" {
  source            = "../../secrets"
  for_each          = local.secrets_merged
  name              = each.value.name
  secrets_to_import = try(each.value.secrets_to_import, [])
  secrets_data = merge(
    each.key == "infrastructure_ssh" ? {
      id_ed25519 = var.app_runner_private_key
    } : {},
    try(each.value.secrets_data, {}),
  )
  labels         = each.value.labels
  annotations    = each.value.annotations
  k8s            = each.value.k8s
  base64_secrets = try(each.value.base64_secrets, false)
}
