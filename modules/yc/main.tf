
module "network" {
  for_each = {
    for network_name, network_obj in var.networks :
    network_name => network_obj
    if network_obj != null
  }
  source = "./network"

  vpc = merge(
    each.value.vpc,
    {
      folder_id = var.project.folder_id
    }
  )
  subnets        = each.value.subnets
  ip_addresses   = try(each.value.ip_addresses, {})
  nat_gws        = each.value.nat_gws
  firewall_rules = each.value.firewall_rules
}
