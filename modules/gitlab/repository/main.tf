resource "gitlab_deploy_key" "keys" {
  for_each = var.deploy_keys
  title    = each.value.name
  project  = var.name
  key      = each.value.key
  #must be opposite of read_only
  can_push = !each.value.read_only
}

resource "gitlab_project_variable" "secrets" {
  for_each = var.secrets
  project  = var.name
  key      = each.value.name
  value    = each.value.text_value
  masked   = true
  hidden   = true
}

resource "gitlab_project_variable" "variable" {
  for_each = var.vars
  project  = var.name
  key      = each.value.name
  value    = each.value.value
}
