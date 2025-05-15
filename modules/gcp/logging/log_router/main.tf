data "google_project" "project" {}

locals {
  # Count how many destination variables are set
  destination_count = (
    (var.gcs_bucket_name != null ? 1 : 0) +
    (var.bq_dataset_name != null ? 1 : 0) +
    (var.log_bucket_name != null ? 1 : 0) +
    (var.pubsub_topic_id != null ? 1 : 0)
  )
  # Validate exactly one destination is specified
  validate_destination = (
    local.destination_count != 1 ?
    file("ERROR: Must specify exactly one destination (gcs_bucket_name, bq_dataset_name, log_bucket_name, or pubsub_topic_id)") : true
  )

  # Determine destination based on which variable is set
  destination = coalesce(
    try("logging.googleapis.com/projects/${data.google_project.project.project_id}/locations/global/buckets/${var.log_bucket_name}", null),
    try("bigquery.googleapis.com/projects/${data.google_project.project.project_id}/datasets/${var.bq_dataset_name}", null),
    try("pubsub.googleapis.com/projects/${data.google_project.project.project_id}/topics/${var.pubsub_topic_id}", null),
    try("storage.googleapis.com/${var.gcs_bucket_name}", null)
  )
}

resource "google_logging_project_sink" "this" {
  project     = data.google_project.project.project_id
  name        = var.name
  destination = local.destination
  filter      = var.filter

  dynamic "exclusions" {
    for_each = var.exclusions != {} ? var.exclusions : {}
    content {
      name        = exclusions.key
      description = exclusions.value.description
      filter      = exclusions.value.filter
    }
  }
}
