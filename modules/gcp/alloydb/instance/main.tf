resource "google_alloydb_instance" "default" {
  cluster           = var.cluster
  instance_id       = var.name
  instance_type     = var.instance_type
  labels            = var.labels
  annotations       = var.annotations
  database_flags    = var.database_flags
  availability_type = var.availability_type
  gce_zone          = var.gce_zone
  display_name      = var.display_name

  machine_config {
    cpu_count    = var.machine_config.cpu_count
    machine_type = var.machine_config.machine_type
  }

  query_insights_config {
    query_string_length     = var.query_insights.query_string_length
    record_application_tags = var.query_insights.record_application_tags
    record_client_address   = var.query_insights.record_client_address
    query_plans_per_minute  = var.query_insights.query_plans_per_minute
  }


  dynamic "read_pool_config" {
    for_each = var.read_pool_config == null ? {} : { "stub" = var.read_pool_config }
    content {
      node_count = read_pool_config.value.node_count
    }
  }

  dynamic "network" {
    for_each = var.network == null ? {} : { "stub" = var.network }
    content {
      authorized_external_networks = network.value.authorized_external_networks
      enable_public_ip             = network.value.enable_public_ip
      enable_outbound_public_ip    = network.value.enable_outbound_public_ip
    }
  }
}
