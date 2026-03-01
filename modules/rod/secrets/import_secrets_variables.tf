locals {
  import_secrets = var.env.initial_start ? {} : {
    for secret_name, secret_obj in var.env.import_secrets :
    "${secret_name}" => {
      name              = secret_obj.name
      secrets_to_import = secret_obj.secrets_to_import
      base64_secrets    = secret_obj.base64_secrets
      k8s = {
        enabled   = secret_obj.k8s_enabled
        namespace = secret_obj.namespace
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
