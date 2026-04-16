output "this" {
  value = merge(
    yandex_kubernetes_cluster.this,
    var.workload_identity_federation != null ? {
      federation = module.federation[0].this
    } : {}
  )
  description = "The Kubernetes cluster resource."
}
