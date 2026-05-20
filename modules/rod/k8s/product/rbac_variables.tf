locals {
  rbac = {
    cluster_role_binding = {
      argocd = lookup(
        {
          gcp = {
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
          }
        },
        var.env.cloud.name,
        null
      )
    }
  }
}
