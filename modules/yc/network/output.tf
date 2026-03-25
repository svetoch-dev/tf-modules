output "vpc" {
  value = {
    network           = module.vpc.network
    network_name      = module.vpc.network_name
    network_id        = module.vpc.network_id
    network_self_link = module.vpc.network_self_link
    project_id        = module.vpc.project_id
    folder_id         = local.folder_id
    peering           = var.vpc.peering
  }
}

output "subnets" {
  value = {
    for subnet_name, subnet_obj in var.subnets :
    subnet_name => merge(
      module.subnet[subnet_name].subnet,
      {
        cloudrun_connector = try(subnet_obj.cloudrun_connector, null) != null ? {
          supported = false
          config    = subnet_obj.cloudrun_connector
        } : null
        secondary_ip_range = subnet_obj.secondary_ip_range
      }
    )
  }
}

output "nats" {
  value = {
    for nat_name, nat_obj in var.nat_gws :
    nat_name => {
      id          = module.nat[nat_name].id
      name        = module.nat[nat_name].name
      router_name = nat_obj.router_name
      subnet_ids = [
        for subnet_name in local.nat_gateway_targets[nat_name] :
        module.subnet[subnet_name].id
      ]
      route_table_ids = [
        for subnet_name in local.nat_gateway_targets[nat_name] :
        module.route_table[subnet_name].id
      ]
      ips = [
        for ip_name in nat_obj.ip_address_names :
        yandex_vpc_address.ip_addresses[ip_name].external_ipv4_address[0].address
      ]
    }
  }
}

output "service_peering" {
  value = null
}

output "firewall_rules" {
  value = {
    for rule_name, rule in var.firewall_rules :
    rule_name => {
      security_group = module.firwall_rules[rule_name].security_group
      target_tags    = rule.target_tags
      deny_rules     = rule.deny
    }
  }
}
