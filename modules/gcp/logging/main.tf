module "log_bucket" {
  source = "./log_bucket"

  for_each = var.log_bucket

  bucket_id      = each.key
  location       = each.value.location
  retention_days = each.value.retention_days
  description    = each.value.description
}

module "log_router" {
  source = "./log_router"

  for_each = var.log_router

  name            = each.key
  gcs_bucket_name = each.value.gcs_bucket_name
  bq_dataset_name = each.value.bq_dataset_name
  log_bucket_name = each.value.log_bucket_name
  pubsub_topic_id = each.value.pubsub_topic_id
  filter          = each.value.filter
  disabled        = each.value.disabled
  exclusions      = each.value.exclusions
}

module "log_audit" {
  source = "./log_audit"

  for_each = var.log_audit

  service = each.value.service
  configs = each.vlaue.configs
}
