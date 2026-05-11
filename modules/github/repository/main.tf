resource "github_repository_deploy_key" "keys" {
  for_each   = var.deploy_keys
  title      = each.value.name
  repository = var.name
  key        = each.value.key
  read_only  = each.value.read_only
}

resource "github_actions_secret" "secrets" {
  for_each = {
    for secret_name, secret_obj in var.secrets :
    secret_name => secret_obj
    if secret_obj != null
  }
  repository  = var.name
  secret_name = each.value.name
  value       = each.value.text_value
}

resource "github_actions_variable" "variable" {
  for_each = {
    for var_name, var_obj in var.vars :
    var_name => var_obj
    if var_obj != null
  }
  repository    = var.name
  variable_name = each.value.name
  value         = each.value.value
}
