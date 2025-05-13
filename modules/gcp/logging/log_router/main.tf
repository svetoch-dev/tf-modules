resource "google_logging_project_sink" "this" {
  name = var.name
  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project eg "logging.googleapis.com/projects/project/locations/global/buckets/test-bucket"
  destination = var.destination
  filter      = var.filter

  dynamic "exclusions" {
    for_each = var.exclusions != null ? var.exclusions : []
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
    }
  }
}