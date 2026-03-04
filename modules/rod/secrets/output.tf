output "rod_secrets" {
  value = {
    for secret_name, secret_obj in module.rod_secrets :
    secret_name => secret_obj.k8s_secrets
  }
  sensitive = true
}
