output "name" {
  value = google_container_node_pool.this.name
}

output "id" {
  value = google_container_node_pool.this.id
}

output "managed_instance_group_urls" {
  value = google_container_node_pool.this.managed_instance_group_urls
}

output "instance_group_urls" {
  value = google_container_node_pool.this.instance_group_urls
}
