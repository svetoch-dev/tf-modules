resource "google_alloydb_cluster" "main" {
  cluster_id        = var.name
  location          = var.region
  database_version  = var.database_version
  labels            = var.labels
  annotations       = var.annotations
  cluster_type      = var.cluster_type
  project           = var.project_id
  subscription_type = var.subscription_type
  deletion_policy   = var.deletion_policy

  dynamic "encryption_config" {
    for_each = var.encryption_config == null ? {} : { "stub" = var.encryption_config }
    content {
      kms_key_name = encryption_config.value.kms_key
    }
  }

  dynamic "network_config" {
    for_each = var.network_config == null ? {} : { "stub" = var.network_config }
    content {
      network            = network_config.value.network
      allocated_ip_range = network_config.value.allocated_ip_range
    }
  }

  dynamic "restore_continuous_backup_source" {
    for_each = var.restore_continuous_backup_source == null ? {} : { "stub" = var.restore_continuous_backup_source }
    content {
      cluster       = restore_continuous_backup_source.value.cluster
      point_in_time = restore_continuous_backup_source.value.point_in_time
    }
  }

  dynamic "continuous_backup_config" {
    for_each = var.continuous_backup_config == null ? {} : { "stub" = var.continuous_backup_config }
    content {
      enabled              = continuous_backup_config.value.enabled
      recovery_window_days = continuous_backup_config.value.recovery_window_days
      dynamic "encryption_config" {
        for_each = continuous_backup_config.value.encryption_config == null ? {} : { "stub" = continuous_backup_config.value.encryption_config }
        content {
          kms_key_name = encryption_config.value.kms_key
        }
      }
    }
  }
}

module "instance" {
  source = "./instance"
  for_each = {
    for instance_name, instance_obj in var.instances :
    instance_name => instance_obj
    if instance_obj.instance_type == "PRIMARY" || instance_obj.instance_type == "SECONDARY"
  }
  cluster           = google_alloydb_cluster.main.name
  name              = each.value.name
  instance_type     = each.value.instance_type
  labels            = each.value.labels
  annotations       = each.value.annotations
  database_flags    = each.value.database_flags
  availability_type = each.value.availability_type
  gce_zone          = each.value.gce_zone
  display_name      = each.value.display_name

  machine_config = each.value.machine_config

  query_insights = each.value.query_insights

  network = each.value.network
}

module "instance_readonly" {
  source = "./instance"
  for_each = {
    for instance_name, instance_obj in var.instances :
    instance_name => instance_obj
    if instance_obj.instance_type == "READ_POOL"
  }
  cluster           = google_alloydb_cluster.main.name
  name              = each.value.name
  instance_type     = each.value.instance_type
  labels            = each.value.labels
  annotations       = each.value.annotations
  database_flags    = each.value.database_flags
  availability_type = each.value.availability_type
  display_name      = each.value.display_name

  machine_config = each.value.machine_config

  query_insights = each.value.query_insights

  read_pool = each.value.read_pool
  network   = each.value.network

  depends_on = [
    module.instance
  ]
}

module "users" {
  source         = "./user"
  for_each       = var.users
  cluster        = google_alloydb_cluster.main.name
  user_id        = each.value.user_id
  user_type      = each.value.user_type
  database_roles = each.value.database_roles
  password       = each.value.password

  depends_on = [
    module.instance
  ]
}
