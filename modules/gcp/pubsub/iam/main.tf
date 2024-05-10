resource "google_pubsub_subscription_iam_binding" "admin" {
  count        = length(var.admins) > 0 && var.is_topic != true ? 1 : 0
  subscription = var.name
  role         = "roles/pubsub.admin"
  members      = var.admins
}

resource "google_pubsub_subscription_iam_binding" "viewer" {
  count        = length(var.viewers) > 0 && var.is_topic != true ? 1 : 0
  subscription = var.name
  role         = "roles/pubsub.viewer"
  members      = var.viewers
}

resource "google_pubsub_subscription_iam_binding" "subscriber" {
  count        = length(var.subscribers) > 0 && var.is_topic != true ? 1 : 0
  subscription = var.name
  role         = "roles/pubsub.subscriber"
  members      = var.subscribers
}

resource "google_pubsub_subscription_iam_binding" "editor" {
  count        = length(var.editors) > 0 && var.is_topic != true ? 1 : 0
  subscription = var.name
  role         = "roles/pubsub.editor"
  members      = var.editors
}

resource "google_pubsub_topic_iam_binding" "publisher" {
  count   = length(var.publishers) > 0 && var.is_topic == true ? 1 : 0
  topic   = var.name
  role    = "roles/pubsub.publisher"
  members = var.publishers
}

resource "google_pubsub_topic_iam_binding" "subscriber" {
  count   = length(var.subscribers) > 0 && var.is_topic == true ? 1 : 0
  topic   = var.name
  role    = "roles/pubsub.subscriber"
  members = var.subscribers
}

resource "google_pubsub_topic_iam_binding" "editor" {
  count   = length(var.editors) > 0 && var.is_topic == true ? 1 : 0
  topic   = var.name
  role    = "roles/pubsub.editor"
  members = var.editors
}

resource "google_pubsub_topic_iam_binding" "admin" {
  count   = length(var.admins) > 0 && var.is_topic == true ? 1 : 0
  topic   = var.name
  role    = "roles/pubsub.admin"
  members = var.admins
}

resource "google_pubsub_topic_iam_binding" "viewer" {
  count   = length(var.viewers) > 0 && var.is_topic == true ? 1 : 0
  topic   = var.name
  role    = "roles/pubsub.viewer"
  members = var.viewers
}
