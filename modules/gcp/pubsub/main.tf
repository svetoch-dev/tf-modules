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

  dynamic "dead_letter_policy" {
    for_each = each.value.dead_letter_topic != null || each.value.max_delivery_attempts != null ? [1] : []
    content {
      dead_letter_topic     = each.value.dead_letter_topic
      max_delivery_attempts = each.value.max_delivery_attempts
    }
  }

  expiration_policy {
    ttl = each.value.ttl
  }
  depends_on = [google_pubsub_topic.this]
}

module "topic_iam_binding" {
  source      = "./iam"
  name        = google_pubsub_topic.this.name
  admins      = try(var.admins, [])
  publishers  = try(var.publishers, [])
  viewers     = try(var.viewers, [])
  subscribers = try(var.subscribers, [])
  editors     = try(var.editors, [])
  is_topic    = true
  depends_on  = [google_pubsub_topic.this]
}

module "subscription_iam_binding" {
  source      = "./iam"
  for_each    = var.subscriptions
  name        = each.key
  admins      = try(each.value.admins, [])
  viewers     = try(each.value.viewers, [])
  subscribers = try(each.value.subscribers, [])
  editors     = try(each.value.editors, [])
  depends_on  = [google_pubsub_subscription.this]
}
