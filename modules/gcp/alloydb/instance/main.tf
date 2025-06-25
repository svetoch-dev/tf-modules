resource "google_alloydb_instance" "main" {
  cluster           = var.cluster_id
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
    for_each = var.read_pool == null ? {} : { "stub" = var.read_pool }
    content {
      node_count = read_pool_config.value.node_count
    }
  }

  dynamic "network_config" {
    for_each = var.network == null ? {} : { "stub" = var.network }
    content {
      dynamic "authorized_external_networks" {
        for_each = network_config.value.authorized_external_networks
        content {
          cidr_range = authorized_external_networks.value.cidr_range
        }
      }
      enable_public_ip          = network_config.value.enable_public_ip
      enable_outbound_public_ip = network_config.value.enable_outbound_public_ip
    }
  }

  dynamic "client_connection_config" {
    for_each = var.client_connection_config == null ? {} : { "stub" = var.client_connection_config }
    content {
      require_connectors = client_connection_config.value.require_connectors
      dynamic "ssl_config" {
        for_each = client_connection_config.value.ssl_config == null ? {} : { "stub" = client_connection_config.value.ssl_config }
        content {
          ssl_mode = ssl_config.value.ssl_mode
        }
      }
    }
  }
}
