data "template_file" "dashboard_json" {
  template = file("${path.module}/templates/dashboard.json.tpl")

  vars = {
    display_name = var.display_name
    columns      = var.columns
    tiles        = var.tiles
  }
}

resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = data.template_file.dashboard_json.rendered
}