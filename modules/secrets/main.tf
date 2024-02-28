locals {
  gcp_secrets_imported = [
    for secret_name in var.secrets_to_import :
    {
      secret_name    = "${var.name}-${secret_name}"
      secret_data    = module.import_secret[secret_name].secret
      annotations    = var.annotations
      labels         = var.labels
      name           = var.name
      base64_secrets = var.base64_secrets
      iam_roles      = var.gcp.iam_roles
      kms_key        = var.gcp.kms_key
    }
    if var.gcp.enabled == true
  ]
  gcp_secrets_data = [
    for secret_name, secret_data in var.secrets_data :
    {
      secret_name    = "${var.name}-${secret_name}"
      secret_data    = secret_data
      annotations    = var.annotations
      labels         = var.labels
      name           = var.name
      base64_secrets = var.base64_secrets
      iam_roles      = var.gcp.iam_roles
      kms_key        = var.gcp.kms_key
    }
    if var.gcp.enabled == true
  ]

  k8s_secrets_data = var.k8s.enabled == true ? [
    {
      secret_name = var.name
      annotations = var.annotations
      labels      = var.labels
      namespace   = var.k8s.namespace
      secret_data = var.secrets_data
    }
  ] : []

  k8s_secrets_imported = var.k8s.enabled == true ? [
    {
      secret_name = var.name
      annotations = var.annotations
      labels      = var.labels
      namespace   = var.k8s.namespace
      secret_data = {
        for secretname in var.secrets_to_import :
        secretname => module.import_secret[secretname].secret
      }
    }
  ] : []

  gcp_secrets = concat(
    local.gcp_secrets_data,
    local.gcp_secrets_imported
  )
  k8s_secrets = concat(
    local.k8s_secrets_imported,
    local.k8s_secrets_data
  )

  all_secrets = concat(
    local.gcp_secrets,
    local.k8s_secrets
  )
}

module "import_secret" {
  source   = "./import_secret"
  for_each = toset(var.secrets_to_import)
  secret   = each.key
}

module "gcp_secrets" {
  source = "../gcp/secret"
  for_each = {
    for secret_obj in local.gcp_secrets :
    secret_obj.secret_name => secret_obj
  }
  annotations = each.value.annotations
  labels      = each.value.labels
  name        = each.key
  is_base64   = each.value.base64_secrets
  iam_roles   = each.value.iam_roles
  kms_key     = each.value.kms_key
  secret      = each.value.secret_data
}

module "k8s_secrets" {
  source = "../k8s/secret"
  for_each = {
    for secret_obj in local.k8s_secrets :
    "${secret_obj.secret_name}.${secret_obj.namespace}" => secret_obj
  }
  annotations = each.value.annotations
  labels      = each.value.labels
  name        = each.value.name
  data        = each.value.secret_data
  namespace   = each.value.namespace
}
