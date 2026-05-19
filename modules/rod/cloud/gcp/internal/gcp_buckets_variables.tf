locals {
  gcp_buckets = {
    format("%s-runners-cache-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection 
      force_destroy        = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class        = "STANDARD"
      location             = var.env.cloud.location.region
      soft_delete_duration = 0
      bucket_policy_only   = true
      admins = [
        "serviceAccount:runner-app@${var.env.cloud.id}.iam.gserviceaccount.com"
      ]
      lifecycle_rules = [{
        action = {
          type = "Delete"
        }
        condition = {
          age = 30
        }
      }]
    }
  }
}
