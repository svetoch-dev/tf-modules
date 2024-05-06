resource "google_pubsub_topic" "topic" {
  name = var.name

#  dynamic "labels" {
#    for_each = var.labels
#    content {
#      labels.key = labels.value.value # doesn't work
#    }
#  }

#  dynamic "message_storage_policy" {
#    for_each = var.regions
#    content {
#      allowed_persistence_regions = message_storage_policy.value
#    }
#  }
}


resource "google_pubsub_subscription" "subscription" {
  for_each = var.subscriptions
  name  = each.key
  topic = google_pubsub_topic.topic[var.name].id
  #depends_on = [
  #  module.pubsub.google_pubsub_topic.topic,#fix it
  #]
}



