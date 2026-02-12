locals {
  gcp_buckets = {
    format("%s-loki-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy      = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = var.env.cloud.buckets.multi_regional ? "MULTI_REGIONAL" : "STANDARD"
      location           = var.env.cloud.buckets.multi_regional ? var.env.cloud.multi_region : var.env.cloud.location.region
      bucket_policy_only = true
      admins = [
        "serviceAccount:grafana-loki@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
      lifecycle_rules = [
      ]
    }
    format("%s-thanos-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy      = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = var.env.cloud.buckets.multi_regional ? "MULTI_REGIONAL" : "STANDARD"
      location           = var.env.cloud.buckets.multi_regional ? var.env.cloud.multi_region : var.env.cloud.location.region
      bucket_policy_only = true
      admins = [
        "serviceAccount:thanos@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
    }
    format("%s-postgres-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy      = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = var.env.cloud.buckets.multi_regional ? "MULTI_REGIONAL" : "STANDARD"
      location           = var.env.cloud.buckets.multi_regional ? var.env.cloud.multi_region : var.env.cloud.location.region
      bucket_policy_only = true
      admins = [
        "serviceAccount:postgres@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
    }
    format("%s-postgres-backup-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy      = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = var.env.cloud.buckets.multi_regional ? "MULTI_REGIONAL" : "STANDARD"
      location           = var.env.cloud.buckets.multi_regional ? var.env.cloud.multi_region : var.env.cloud.location.region
      bucket_policy_only = true
      admins = [
        "serviceAccount:postgres@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
      lifecycle_rules = [{
        action = {
          type = "Delete"
        },
        condition = {
          age = "60"
        }
      }]
    }
    format("%s-logs-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection 
      force_destroy      = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = "STANDARD"
      location           = var.env.cloud.location.region
      bucket_policy_only = true
      admins = [
        "serviceAccount:fluent@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
      viewers = [
      ]
      creators = var.env.initial_start ? [] : [
        "serviceAccount:service-$${project_numeric_id}@gcp-sa-logging.iam.gserviceaccount.com"
      ]
      lifecycle_rules = [{
        action = {
          type = "Delete"
        },
        condition = {
          age = "1"
        }
      }]
    }
  }
}
