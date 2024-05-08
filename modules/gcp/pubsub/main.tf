resource "google_pubsub_topic" "this" {
  name                       = var.name
  message_retention_duration = var.message_retention_duration

  dynamic "message_storage_policy" {
    for_each = length(var.regions) > 0 ? [1] : []
    content {
      allowed_persistence_regions = var.regions
    }
  }
}

resource "google_pubsub_subscription" "this" {
  for_each                     = var.subscriptions
  name                         = each.key
  topic                        = google_pubsub_topic.this.id
  message_retention_duration   = each.value.message_retention_duration
  retain_acked_messages        = each.value.retain_acked_messages
  ack_deadline_seconds         = each.value.ack_deadline_seconds
  enable_message_ordering      = each.value.enable_message_ordering
  filter                       = each.value.filter
  enable_exactly_once_delivery = each.value.enable_exactly_once_delivery

  dynamic "retry_policy" {
    for_each = each.value.minimum_backoff != null || each.value.maximum_backoff != null ? [1] : []
    content {
      minimum_backoff = each.value.minimum_backoff
      maximum_backoff = each.value.maximum_backoff
    }
  }

  expiration_policy {
    ttl = each.value.ttl
  }

  dynamic "cloud_storage_config" {
    for_each = each.value.cloud_storage != null ? [each.value.cloud_storage] : []
    content {
      bucket          = cloud_storage_config.key
      filename_prefix = cloud_storage_config.value.filename_prefix
      filename_suffix = cloud_storage_config.value.filename_suffix
      max_bytes       = cloud_storage_config.value.max_bytes
      max_duration    = cloud_storage_config.value.max_duration

      dynamic "avro_config" {
        for_each = cloud_storage_config.value.write_metadata != null ? [1] : []
        content {
          write_metadata = cloud_storage_config.value.write_metadata
        }
      }
    }
  }

  depends_on = [google_pubsub_topic.this]
}

resource "google_pubsub_topic_iam_binding" "publisher" {
  count      = length(var.publishers) > 0 ? 1 : 0
  project    = google_pubsub_topic.this.project
  topic      = google_pubsub_topic.this.name
  role       = "roles/pubsub.publisher"
  members    = var.publishers
  depends_on = [google_pubsub_topic.this]
}

resource "google_pubsub_topic_iam_binding" "subscriber" {
  count      = length(var.subscribers) > 0 ? 1 : 0
  project    = google_pubsub_topic.this.project
  topic      = google_pubsub_topic.this.name
  role       = "roles/pubsub.subscriber"
  members    = var.subscribers
  depends_on = [google_pubsub_topic.this]
}

resource "google_pubsub_topic_iam_binding" "editor" {
  count      = length(var.editors) > 0 ? 1 : 0
  project    = google_pubsub_topic.this.project
  topic      = google_pubsub_topic.this.name
  role       = "roles/pubsub.editor"
  members    = var.editors
  depends_on = [google_pubsub_topic.this]
}

resource "google_pubsub_topic_iam_binding" "admin" {
  count      = length(var.admins) > 0 ? 1 : 0
  project    = google_pubsub_topic.this.project
  topic      = google_pubsub_topic.this.name
  role       = "roles/pubsub.admin"
  members    = var.admins
  depends_on = [google_pubsub_topic.this]
}

resource "google_pubsub_topic_iam_binding" "viewer" {
  count      = length(var.viewers) > 0 ? 1 : 0
  project    = google_pubsub_topic.this.project
  topic      = google_pubsub_topic.this.name
  role       = "roles/pubsub.viewer"
  members    = var.viewers
  depends_on = [google_pubsub_topic.this]
}

module "subscription_iam_binding" {
  source      = "./subscription_iam"
  for_each    = var.subscriptions
  name        = each.key
  admins      = try(each.value.admins, [])
  viewers     = try(each.value.viewers, [])
  subscribers = try(each.value.subscribers, [])
  editors     = try(each.value.editors, [])
  depends_on  = [google_pubsub_subscription.this]
}
