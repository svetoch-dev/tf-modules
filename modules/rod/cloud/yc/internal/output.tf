output "network" {
  value = module.internal.network
}

output "iam" {
  value = module.internal.iam
}

output "k8s_clusters" {
  value = module.internal.k8s_clusters
}

output "registries" {
  value = module.internal.registries
}
