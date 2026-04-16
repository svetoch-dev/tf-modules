module "roles" {
  source = "./role"
  for_each = {
    for role_name, role_obj in var.roles :
    role_name => role_obj
    if role_obj != null
  }

  folder_id = var.folder_id
  role      = each.value.role
  members   = each.value.members
}

module "oidc_federations" {
  source = "./oidc_federation"
  for_each = {
    for federation_name, federation_obj in var.oidc_federations :
    federation_name => federation_obj
    if federation_obj != null
  }

  name        = each.key
  folder_id   = var.folder_id
  issuer      = each.value.issuer
  jwks_url    = each.value.jwks_url
  audiences   = each.value.audiences
  description = each.value.description
  disabled    = each.value.disabled
  labels      = each.value.labels
  timeouts    = each.value.timeouts
}

module "service_accounts" {
  source = "./service_account"
  for_each = {
    for service_account_name, service_account_obj in var.service_accounts :
    service_account_name => service_account_obj
    if service_account_obj != null
  }

  folder_id             = var.folder_id
  name                  = each.value.name == null ? each.key : each.value.name
  description           = each.value.description
  roles                 = each.value.roles
  sa_iam_bindings       = each.value.sa_iam_bindings
  generate_key          = each.value.generate_key
  federated_credentials = each.value.federated_credentials
}
