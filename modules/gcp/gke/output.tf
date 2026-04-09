output "clusters" {
  value       = module.cluster.this
  description = "The Kubernetes cluster resource."
}

output "node_pools" {
  value = merge(
    [
      for cluster_name, cluster_obj in module.node_pool : {
        for pool_name, pool_obj in cluster_obj.node_pools :
        "${cluster_name}/${pool_name}" => pool_obj.this
      }
    ]
  )
  description = "The Kubernetes node pools resources."
}
