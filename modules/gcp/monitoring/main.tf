module "log_metric" {
  source              = "./log_metrics"
  for_each            = var.log_metrics
  metric_name         = each.value.name
  filter              = each.value.filter
  metric_descriptor   = each.value.metric_descriptor
  value_extractor     = each.value.value_extractor
  disabled            = each.value.disabled
  bucket_type         = each.value.bucket_type
  linear_buckets      = each.value.linear_buckets
  exponential_buckets = each.value.exponential_buckets
  explicit_buckets    = each.value.explicit_buckets
}