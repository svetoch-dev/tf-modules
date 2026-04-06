output "cluster" {
  value       = module.cluster.this
  description = "The Kubernetes cluster resource."
}

output "node_groups" {
  value = {
    for node_group_name, node_group in module.node_groups :
    node_group_name => node_group.this
  }
  description = "The Kubernetes node group resources."
}
