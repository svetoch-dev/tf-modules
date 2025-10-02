resource "google_logging_project_bucket_config" "this" {
  project        = var.project_id
  location       = var.location
  retention_days = var.retention_days
  bucket_id      = var.bucket_id
  description    = var.description
}
