resource "google_logging_metric" "logging_metric" {
  name   = var.metric_name
  filter = var.filter

  metric_descriptor {
    metric_kind = var.metric_kind
    value_type  = var.value_type 
    unit        = var.unit
    display_name = var.display_name

    dynamic "labels" {
      for_each = var.labels
      content {
        key         = labels.value.key
        value_type  = labels.value.value_type
        description = labels.value.description
      }
    }
  }

  value_extractor = var.value_extractor
  disabled        = var.disabled

  dynamic "label_extractors" {
    for_each = var.label_extractors
    content {
      key   = label_extractors.key
      value = label_extractors.value
    }
  }

  // Добавляем bucket_options, только если они заданы
  dynamic "bucket_options" {
    for_each = var.bucket_type == "linear" && var.linear_buckets != null ? [1] : []
    content {
      linear_buckets {
        num_finite_buckets = var.linear_buckets.num_finite_buckets
        width              = var.linear_buckets.width
        offset             = var.linear_buckets.offset
      }
    }
  }

  dynamic "bucket_options" {
    for_each = var.bucket_type == "exponential" && var.exponential_buckets != null ? [1] : []
    content {
      exponential_buckets {
        num_finite_buckets = var.exponential_buckets.num_finite_buckets
        growth_factor      = var.exponential_buckets.growth_factor
        scale              = var.exponential_buckets.scale
      }
    }
  }

  dynamic "bucket_options" {
    for_each = var.bucket_type == "explicit" && var.explicit_buckets != null ? [1] : []
    content {
      explicit_buckets {
        bounds = var.explicit_buckets
      }
    }
  }
}
