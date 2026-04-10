locals {
  yc_buckets = {
    format("%s-loki-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccount:${module.yc.iam.service_accounts["grafana-loki"].id}"
      ]
    }
    format("%s-thanos-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccount:${module.yc.iam.service_accounts["thanos"].id}"
      ]
    }
    format("%s-postgres-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccount:${module.yc.iam.service_accounts["postgres"].id}"
      ]
    }
    format("%s-postgres-backup-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admins = [
        "serviceAccount:${module.yc.iam.service_accounts["postgres"].id}"
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
        "serviceAccount:${module.yc.iam.service_accounts["fluent"].id}"
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
        "serviceAccount:${module.yc.iam.service_accounts["runner-app"].id}"
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
