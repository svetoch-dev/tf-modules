output "network" {
  value = module.internal.network
}

output "k8s_clusters" {
  value = module.internal.k8s_clusters
}

output "iam" {
  value     = module.internal.iam
  sensitive = true
}

output "registries" {
  value = module.internal.registries
}
