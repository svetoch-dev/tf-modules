locals {
  password_choice = var.password == null ? random_password.password.result : var.password
  password        = var.user_type == "ALLOYDB_BUILT_IN" ? local.password_choice : null
}


resource "google_alloydb_user" "user" {
  cluster   = var.cluster_id
  user_id   = var.user_id
  user_type = var.user_type
  password  = local.password

  database_roles = var.database_roles
}

resource "random_password" "password" {
  length  = 32
  special = false
}
