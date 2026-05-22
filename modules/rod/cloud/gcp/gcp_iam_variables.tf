locals {
  gcp_iam = {
    custom_roles = {
      k8sNodeServiceAccount = {
        title       = "k8s node service account"
        description = "Cusom role for k8s node service accounts without the bucket read permission"
        permissions = [
          "autoscaling.sites.writeMetrics",
          "logging.logEntries.create",
          "monitoring.metricDescriptors.create",
          "monitoring.metricDescriptors.list",
          "monitoring.timeSeries.create",
          "monitoring.timeSeries.list",
          "resourcemanager.projects.get",
          "serviceusage.services.use",
        ]
      }
      bucketList = {
        title       = "List/get buckets for services"
        description = "Custom role for listing buckets and there metadata"
        permissions = [
          "resourcemanager.projects.get",
          "storage.buckets.list",
          "storage.buckets.get",
        ]
      }
      developers = {
        title       = "developer"
        description = "Custom role for developers"
        permissions = [
          "storage.buckets.list",
          "storage.buckets.get",
          "container.clusters.get",
          "observability.scopes.get",
          "resourcemanager.projects.get",
        ]
      }
    }
    service_accounts = {
      k8s-nodes = {
        description = "default service account for k8s nodes"
        roles = [
          "projects/${var.env.cloud.id}/roles/k8sNodeServiceAccount"
        ]
        generate_key = false
      }
      external-dns = {
        description = "k8s sigs external dns service account"
        roles = [
          "roles/dns.admin"
        ]
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[external-dns/external-dns]",
          ]
        }
        generate_key = false
      },
      thanos = {
        description = "service account for thanos"
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[prometheus/thanos]",
          ]
        }
        generate_key = false
      }
      postgres = {
        description = "service account for postgres-operator to store wal-e archiving"
        roles = [
          "projects/${var.env.cloud.id}/roles/bucketList"
        ]
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = concat(
            [
              "serviceAccount:${var.env.cloud.id}.svc.id.goog[postgres/postgres]",
            ],
            [
              for app_name, app_obj in var.env.apps :
              "serviceAccount:${var.env.cloud.id}.svc.id.goog[${app_obj.name}/postgres]"
              if app_obj.postgres == true
            ]
          )
        }
        generate_key = false
      }
      grafana-loki = {
        description = "service account for loki"
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[loki/grafana-loki]",
          ]
        }
        generate_key = false
      }
      fluent = {
        description = "service account for fluent"
        roles = [
          "projects/${var.env.cloud.id}/roles/bucketList"
        ]
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[fluent/fluent]",
          ]
        }
        generate_key = false
      }
    }

    roles = {
      devs = {
        role = "projects/${var.env.cloud.id}/roles/developers"
        members = [
          for user_name, user_obj in var.env.users :
          "user:${user_obj.name}"
          if contains(user_obj.roles, "dev")
        ]
      }
    }
  }
}
