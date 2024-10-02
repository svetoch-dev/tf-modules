resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = templatefile("${path.module}/templates/dashboard.json.tpl", {
    display_name = var.display_name
    columns      = var.columns
    widgets      = var.widgets
  })
}
