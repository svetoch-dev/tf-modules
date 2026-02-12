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
        sa_iam_bindings = {
        }
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
        roles       = []
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
              for app_name, app_obj in var.apps :
              "serviceAccount:${var.env.cloud.id}.svc.id.goog[${app_obj.name}/postgres]"
            ]
          )
        }
        generate_key = false
      }
      argocd = {
        description = "argocd service account"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[argocd/argocd]",
          ]
        }
        generate_key = false
      },
      grafana-loki = {
        description  = "service account for loki"
        roles        = []
        custom_roles = []
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
        custom_roles = []
        sa_iam_bindings = var.env.initial_start ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[fluent/fluent]",
          ]
        }
        generate_key = false
      }
      runner = {
        description = "service account for ci runners"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = var.env.initial_start || var.ci == null ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[${var.ci.type}-runner/runner]"
          ]
        }
        generate_key = false
      }
      runner-app = {
        description  = "service account for app ci runners"
        roles        = []
        custom_roles = []
        sa_iam_bindings = var.env.initial_start || var.ci == null ? {} : {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.env.cloud.id}.svc.id.goog[${var.ci.type}-runner-app/runner-app]"
          ]
        }
        generate_key = false
      }
    }

    roles = {
    }
  }
}
