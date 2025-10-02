resource "google_project_iam_audit_config" "this" {
  project = data.google_project.project.project_id
  service = var.service
  dynamic "audit_log_config" {
    for_each = var.configs
    content {
      log_type         = each.value.audit_log_config.type
      exempted_members = each.value.audit_log_config.exempted_members
    }
  }
}

data "google_project" "project" {}
