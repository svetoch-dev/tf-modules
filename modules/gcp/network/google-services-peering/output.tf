output "managed_subnet" {
  value = google_compute_global_address.google_managed_subnet
}

output "service_peering_connection" {
  value = google_service_networking_connection.google_service_peering_connection
}
