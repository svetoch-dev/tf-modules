resource "kubernetes_namespace" "namespaces" {
  for_each = {
    for namespace_name, namespace_obj in var.namespaces :
    namespace_name => namespace_obj
    if namespace_obj != null
  }
  metadata {
    annotations = each.value.annotations
    labels      = each.value.labels
    name        = each.value.name
  }
}
