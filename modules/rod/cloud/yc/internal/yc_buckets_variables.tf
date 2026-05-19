locals {
  yc_buckets = {
    format("%s-runners-cache-%s", var.company.name, var.env.short_name) = {
      #force_destroy should be oposite to deletion_protection 
      force_destroy = var.env.cloud.buckets.deletion_protection ? false : true
      storage_class = "STANDARD"
      admin_names = [
        "serviceAccountName:runner-app-${var.env.short_name}"
      ]
      lifecycle_rules = [{
        enabled = true
        expiration = {
          days = 30
        }
      }]
    }
  }
}
