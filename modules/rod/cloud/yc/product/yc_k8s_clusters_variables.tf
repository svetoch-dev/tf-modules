locals {
  yc_k8s_clusters = var.env.kubernetes.enabled ? {
    tostring(var.env.short_name) = {
      admin_names = [
        "serviceAccountName:${var.int_env.cloud.folder_id}:argocd-${var.int_env.short_name}"
      ]
    }
  } : {}
}
