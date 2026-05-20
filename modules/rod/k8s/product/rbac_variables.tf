locals {
  rbac = {
    cluster_role_binding = {
      argocd = var.env.cloud.type == "gcp" ? {
        labels      = {},
        annotations = {},
        role_ref = {
          kind = "ClusterRole"
          name = "cluster-admin"
        }
        subject = {
          argocd = {
            api_group = "rbac.authorization.k8s.io"
            kind      = "User"
            name      = "argocd@${var.int_env.cloud.id}.iam.gserviceaccount.com"
            namespace = ""
          }
        }
      } : null
    }
  }
}
