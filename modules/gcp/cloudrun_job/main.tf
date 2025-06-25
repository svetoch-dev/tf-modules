resource "google_cloud_run_v2_job" "this" {
  name     = var.name
  location = var.location

  template {
    labels      = var.labels
    parallelism = var.parallelism
    template {
      execution_environment = var.execution_environment
      service_account       = var.service_account
      timeout               = var.timeout
      max_retries           = var.max_retries
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

      dynamic "containers" {
        for_each = var.containers

        content {
          image   = containers.value.image
          command = containers.value.command
          args    = containers.value.args

          dynamic "volume_mounts" {
            for_each = containers.value.volume_mounts == null ? {} : containers.value.volume_mounts
            content {
              name       = volume_mounts.value.name
              mount_path = volume_mounts.value.path
            }
          }

          dynamic "ports" {
            for_each = containers.value.ports
            content {
              container_port = ports.value.container_port
              name           = ports.value.name
            }
          }

          dynamic "env" {
            for_each = containers.value.env
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
              memory = containers.value.resources.limits.memory
              cpu    = containers.value.resources.limits.cpu
            }
          }
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
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].template[0].containers[0].image,
      client,
      client_version
    ]
  }
}
