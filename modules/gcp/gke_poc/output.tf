output "name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = google_container_cluster.primary.master_version
}

output "location" {
  description = "Cluster location"
  value       = google_container_cluster.primary.location
}
