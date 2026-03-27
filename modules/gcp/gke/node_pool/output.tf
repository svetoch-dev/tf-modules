output "name" {
  value = google_container_node_pool.node_pool.name
}

output "id" {
  value = google_container_node_pool.node_pool.id
}

output "managed_instance_group_urls" {
  value = google_container_node_pool.node_pool.managed_instance_group_urls
}

output "instance_group_urls" {
  value = google_container_node_pool.node_pool.instance_group_urls
}
