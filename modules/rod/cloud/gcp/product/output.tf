output "network" {
  value = module.product.network
}

output "k8s_clusters" {
  value = module.product.k8s_clusters
}

output "iam" {
  value     = module.product.iam
  sensitive = true
}

output "registries" {
  value = module.product.registries
}
