output "tiles" {
  value = var.tiles
}

output "dashboard_json" {
  value = data.template_file.dashboard_json
}