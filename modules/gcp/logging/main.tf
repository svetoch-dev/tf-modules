module "log_bucket" {
  source = "./log_bucket"

  for_each = { for bucket in var.log_bucket : bucket.bucket_id => bucket }

  location       = each.value.location
  retention_days = each.value.retention_days
  bucket_id      = each.value.bucket_id
}

module "log_router" {
  source = "./log_router"
  
  for_each = { for sink in var.log_router : sink.name => sink }
  name        = each.value.name
  destination = each.value.destination
  filter      = each.value.filter
  exclusions  = each.value.exclusions
}