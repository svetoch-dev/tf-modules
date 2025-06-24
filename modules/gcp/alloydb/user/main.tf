locals {
  password_choice = var.password == null ? random_password.password[0].result : var.password
  password        = var.user_type == "ALLOYDB_BUILT_IN" ? local.password_choice : null
}


resource "google_alloydb_user" "user" {
  cluster   = var.cluster
  user_id   = var.user_id
  user_type = var.user_type
  password  = local.password

  database_roles = var.database_roles
}

resource "random_password" "password" {
  count   = var.password == null && var.user_type == "ALLOYDB_BUILT_IN" ? 1 : 0
  length  = 32
  special = false
}
