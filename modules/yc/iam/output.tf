output "service_accounts" {
  value = {
    for sa_name, sa_obj in module.service_accounts :
    sa_name => sa_obj.this
  }
}
