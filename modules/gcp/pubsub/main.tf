resource "google_pubsub_topic" "this" {
  name                       = var.name
  message_retention_duration = var.message_retention_duration
  #  dynamic "labels" {
  #    for_each = var.labels
  #    content {
  #      labels.key = labels.value.value # doesn't work
  #    }
  #  }

  dynamic "message_storage_policy" {
    for_each = length(var.regions) > 0 ? [1] : [0]
    content {
      allowed_persistence_regions = var.regions
    }
  }
}

resource "google_pubsub_subscription" "this" {
  for_each   = var.subscriptions
  name       = each.key
  topic      = google_pubsub_topic.this.id
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
