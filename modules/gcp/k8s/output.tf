output "cluster" {
  value       = module.cluster.this
  description = "The Kubernetes cluster resource."
}

output "node_pools" {
  value = {
    for node_pool_name, node_pool in module.node_pool :
    node_pool_name => node_pool.this
  }
  description = "The Kubernetes node pools resources."
}
