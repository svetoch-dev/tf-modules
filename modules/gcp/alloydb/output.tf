output "users" {
  description = "Alloydb users"
  value = {
    for user_name, user_obj in module.users :
    user_name => user_obj.user
  }
}

output "instances" {
  description = "Alloydb instances"
  value = {
    for instance_name, instance_obj in merge(module.instances, module.instances_readonly) :
    instance_name => instance_obj.instance
  }
}

output "cluster" {
  description = "Alloydb cluster"
  value       = google_alloydb_cluster.main
}
