locals {
  yc_buckets = {
    format("%s-loki-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccountName:grafana-loki"
      ]
    }
    format("%s-thanos-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccountName:thanos"
      ]
    }
    format("%s-postgres-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccountName:postgres"
      ]
    }
    format("%s-postgres-backup-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccountName:postgres"
      ]
      lifecycle_rules = [{
        enabled = true
        expiration = {
          days = 60
        }
      }]
    }
    format("%s-logs-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection 
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccountName:fluent"
      ]
      lifecycle_rules = [{
        enabled = true
        expiration = {
          days = 1
        }
      }]
    }
    format("%s-runners-cache-%s", var.company.name, var.env.short_name) = var.env.short_name == "int" ? {
      #force_destroy should be oposite to deletion_protection 
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccountName:runner-app"
      ]
      lifecycle_rules = [{
        enabled = true
        expiration = {
          days = 30
        }
      }]
    } : null
  }
}
