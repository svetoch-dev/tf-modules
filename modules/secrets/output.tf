output "gcp_secrets" {
  value = {
    for secret_obj in local.gcp_secrets :
    secret_obj.secret_name => merge(
      secret_obj,
      {
        gcp = secret_obj.enabled == true ? module.gcp_secrets[secret_obj.secret_name].secret : null
      }
    )
  }
  sensitive = true
}

output "k8s_secrets" {
  value = {
    for secret_obj in local.k8s_secrets :
    secret_obj.secret_name => merge(
      secret_obj,
      {
        k8s = secret_obj.enabled == true ? module.k8s_secrets["${secret_obj.secret_name}.${secret_obj.namespace}"].secret : null
      }
    )
  }
  sensitive = true
}
