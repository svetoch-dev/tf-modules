module "log_bucket" {
  source = "./log_bucket"

  for_each = { for bucket in var.log_bucket : bucket.bucket_id => bucket }

  location       = each.value.location
  retention_days = each.value.retention_days
  bucket_id      = each.value.bucket_id
}