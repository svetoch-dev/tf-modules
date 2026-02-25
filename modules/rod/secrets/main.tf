
module "secrets" {
  source            = "git::https://github.com/svetoch-dev/tf-modules.git//modules/secrets?ref=gcp-v2.8.4"
  for_each          = local.secrets_merged
  name              = each.value.name
  secrets_to_import = try(each.value.secrets_to_import, [])
  secrets_data      = try(each.value.secrets_data, {})
  labels            = each.value.labels
  annotations       = each.value.annotations
  k8s               = each.value.k8s
  base64_secrets    = try(each.value.base64_secrets, false)
}
