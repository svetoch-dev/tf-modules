module "custom_roles" {
  source = "./custom_role"
  for_each = {
    for custom_role_name, custom_role_obj in var.custom_roles :
    custom_role_name => custom_role_obj
    if custom_role_obj != null
  }
  name        = each.key
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions

}

module "roles" {
  source = "./role"
  for_each = {
    for role_name, role_obj in var.roles :
    role_name => role_obj
    if role_obj != null
  }

  project_id = var.project_id
  role       = each.value.role
  members    = each.value.members
}

module "service_accounts" {
  source = "./service_account"
  for_each = {
    for service_account_name, service_account_obj in var.service_accounts :
    service_account_name => service_account_obj
    if service_account_obj != null
  }
  project_id      = var.project_id
  name            = each.key
  description     = each.value.description
  roles           = each.value.roles
  sa_iam_bindings = each.value.sa_iam_bindings
  generate_key    = each.value.generate_key
}
