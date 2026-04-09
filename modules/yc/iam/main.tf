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

module "service_accounts" {
  source = "./service_account"
  for_each = {
    for service_account_name, service_account_obj in var.service_accounts :
    service_account_name => service_account_obj
    if service_account_obj != null
  }

  folder_id       = var.folder_id
  name            = each.key
  description     = each.value.description
  roles           = each.value.roles
  sa_iam_bindings = each.value.sa_iam_bindings
  generate_key    = each.value.generate_key
}
