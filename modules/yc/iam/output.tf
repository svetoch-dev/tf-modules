output "oidc_federations" {
  value = {
    for federation_name, federation_obj in module.oidc_federations :
    federation_name => federation_obj.this
  }
}

output "service_accounts" {
  value = {
    for sa_name, sa_obj in module.service_accounts :
    sa_name => sa_obj.this
  }
}
