resource "google_project_iam_audit_config" "this" {
  project = data.google_project.project.project_id
  service = var.service
  dynamic "audit_log_config" {
    for_each = var.configs
    content {
      log_type         = audit_log_config.value.type
      exempted_members = audit_log_config.value.exempted_members
    }
  }
}

data "google_project" "project" {}
