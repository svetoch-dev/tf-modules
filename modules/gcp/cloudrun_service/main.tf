resource "google_cloud_run_v2_service" "this" {
  name                = var.name
  location            = var.location
  deletion_protection = var.deletion_protection
  ingress             = var.ingress

  template {
    execution_environment            = var.execution_environment
    max_instance_request_concurrency = var.max_instance_requests
    timeout                          = var.request_timeout
    service_account                  = var.service_account
    labels                           = var.labels
    dynamic "volumes" {
      for_each = var.volumes
      content {
        name = volumes.value.name
        secret {
          secret = volumes.value.secret.secret
          items {
            version = volumes.value.secret.items.version
            path    = volumes.value.secret.items.path
          }
        }
      }
    }

    containers {
      image = var.container.image

      dynamic "startup_probe" {
        for_each = var.container.startup_probe == null ? [] : [var.container.startup_probe]
        content {
          failure_threshold     = try(startup_probe.value.failure_threshold, null)
          initial_delay_seconds = try(startup_probe.value.initial_delay_seconds, null)
          period_seconds        = try(startup_probe.value.period_seconds, null)
          timeout_seconds       = try(startup_probe.value.timeout_seconds, null)

          dynamic "http_get" {
            for_each = try(startup_probe.value.http_get, null) == null ? [] : [startup_probe.value.http_get]
            content {
              path = try(http_get.value.path, null)
              port = try(http_get.value.port, null)

              dynamic "http_headers" {
                for_each = try(http_get.value.http_headers, [])
                content {
                  name  = http_headers.value.name
                  value = http_headers.value.value
                }
              }
            }
          }

          dynamic "tcp_socket" {
            for_each = try(startup_probe.value.tcp_socket, null) == null ? [] : [startup_probe.value.tcp_socket]
            content {
              port = try(tcp_socket.value.port, null)
            }
          }
        }
      }

      dynamic "liveness_probe" {
        for_each = var.container.liveness_probe == null ? [] : [var.container.liveness_probe]
        content {
          failure_threshold     = try(liveness_probe.value.failure_threshold, null)
          initial_delay_seconds = try(liveness_probe.value.initial_delay_seconds, null)
          period_seconds        = try(liveness_probe.value.period_seconds, null)
          timeout_seconds       = try(liveness_probe.value.timeout_seconds, null)

          dynamic "http_get" {
            for_each = try(liveness_probe.value.http_get, null) == null ? [] : [liveness_probe.value.http_get]
            content {
              path = try(http_get.value.path, null)
              port = try(http_get.value.port, null)

              dynamic "http_headers" {
                for_each = try(http_get.value.http_headers, [])
                content {
                  name  = http_headers.value.name
                  value = http_headers.value.value
                }
              }
            }
          }

          dynamic "grpc" {
            for_each = try(liveness_probe.value.grpc, null) == null ? [] : [liveness_probe.value.grpc]
            content {
              service = try(grpc.value.service, null)
            }
          }
        }
      }

      dynamic "volume_mounts" {
        for_each = var.container.volume_mounts == null ? {} : var.container.volume_mounts
        content {
          name       = volume_mounts.value.name
          mount_path = volume_mounts.value.path
        }
      }

      dynamic "ports" {
        for_each = var.container.ports
        content {
          container_port = ports.value.container_port
          name           = ports.value.name
        }
      }

      dynamic "env" {
        for_each = var.container.env
        content {
          name  = env.value.name
          value = env.value.value
          dynamic "value_source" {
            for_each = env.value.secret_key_ref != null ? {
              "secret_key_ref" = env.value.secret_key_ref
            } : {}
            content {
              secret_key_ref {
                secret  = value_source.value.secret
                version = value_source.value.version
              }
            }
          }
        }
      }

      resources {
        limits = {
          memory = var.container.resources.limits.memory
          cpu    = var.container.resources.limits.cpu
        }
        cpu_idle          = var.container.resources.cpu_idle
        startup_cpu_boost = var.container.resources.startup_cpu_boost
      }
    }

    dynamic "vpc_access" {
      for_each = var.vpc_access != null ? [
        var.vpc_access
      ] : []
      content {
        connector = vpc_access.value.connector
        egress    = vpc_access.value.egress
      }
    }

    scaling {
      min_instance_count = var.scaling.min_instance_count
      max_instance_count = var.scaling.max_instance_count
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version
    ]
  }
}

resource "google_cloud_run_service_iam_member" "authorize" {
  count    = length(var.members)
  location = google_cloud_run_v2_service.this.location
  project  = google_cloud_run_v2_service.this.project
  service  = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = var.members[count.index]
}

resource "google_compute_region_network_endpoint_group" "this" {
  count                 = var.neg_enabled ? 1 : 0
  name                  = "${var.name}-neg"
  region                = var.location
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_v2_service.this.name
  }
}

resource "google_cloud_run_domain_mapping" "this" {
  for_each = var.domains
  location = var.location
  name     = each.value.name

  spec {
    route_name = google_cloud_run_v2_service.this.name
  }
  metadata {
    namespace = var.project_id
  }
}

