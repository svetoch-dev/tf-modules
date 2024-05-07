resource "google_pubsub_topic" "this" {
  name                       = var.name
  message_retention_duration = var.message_retention_duration
}

resource "google_pubsub_subscription" "this" {
  for_each = var.subscriptions
  name     = each.key
  topic    = google_pubsub_topic.this.id

  dynamic "cloud_storage_config" {
    for_each = each.value.cloud_storage
    content {
      bucket          = cloud_storage_config.key
      filename_prefix = cloud_storage_config.value.filename_prefix
      filename_suffix = cloud_storage_config.value.filename_suffix
      max_bytes       = cloud_storage_config.value.max_bytes
      max_duration    = cloud_storage_config.value.max_duration

      dynamic "avro_config" {
        for_each = cloud_storage_config.value.avro_config
        content {
          write_metadata = avro_config.value.write_metadata
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
