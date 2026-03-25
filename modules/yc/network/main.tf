locals {
  subnet_default_gateway = {
    for subnet_name, subnet_obj in var.subnets :
    tostring(subnet_name) => merge(
      {
        for nat_gw_name, nat_gw_obj in var.nat_gws :
        "gateway" => module.nat_gws[nat_gw_name].this.id
        if contains(nat_gw_obj.subnetworks, nat_gw_obj.name)
      },
      {
        for nat_gw_name, nat_gw_obj in var.nat_gws :
        "gateway" => module.nat_gws[nat_gw_name].this.id
        if nat_gw_obj.subnetwork_ip_ranges_to_nat == "ALL_SUBNETWORKS"
      }
    )
  }

  firewall_rules_egress = {
    for firewall_rule_name, firewall_rule_obj in var.firewall_rules :
    tostring(firewall_rule_name) => {
      name       = try(firewall_rule_obj.name, firewall_rule_name)
      folder_id  = module.vpc.this.folder_id
      network_id = module.vpc.this.id
      egress = flatten(
        [
          for protocol, protocol_obj in firewall_rule_obj.allow :
          [
            for port in protocol_obj.ports :
            {
              protocol       = upper(protocol == "all" ? "ANY" : protocol)
              v4_cidr_blocks = firewall_rule_obj.source_ranges
              port           = port
            }
          ]
        ]
      )

      ingress = []
    }
    if firewall_rule_obj.direction == "EGRESS"
  }

  firewall_rules_ingress = {
    for firewall_rule_name, firewall_rule_obj in var.firewall_rules :
    tostring(firewall_rule_name) => {
      name       = try(firewall_rule_obj.name, firewall_rule_name)
      folder_id  = module.vpc.this.folder_id
      network_id = module.vpc.this.id
      ingress = flatten(
        [
          for protocol, protocol_obj in firewall_rule_obj.allow :
          [
            for port in protocol_obj.ports :
            {
              protocol       = upper(protocol == "all" ? "ANY" : protocol)
              v4_cidr_blocks = firewall_rule_obj.source_ranges
              port           = port
            }
          ]
        ]
      )

      egress = []
    }
    if firewall_rule_obj.direction == "INGRESS"
  }

}

module "vpc" {
  source      = "./vpc"
  folder_id   = var.vpc.folder_id
  name        = var.vpc.name
  description = var.vpc.description
  labels      = var.vpc.labels
  timeouts    = var.vpc.timeouts
}

module "nat_gws" {
  source      = "./gateway"
  for_each    = var.nat_gws
  name        = try(each.value.name, each.key)
  description = each.value.description
  folder_id   = module.vpc.this.folder_id
  labels      = each.value.labels
  timeouts    = each.value.timeouts
}

module "route_tables" {
  source     = "./route_table"
  for_each   = var.subnets
  name       = try(each.value.name, each.key)
  folder_id  = module.vpc.this.folder_id
  network_id = module.vpc.this.id
  labels     = each.value.labels
  static_routes = concat(
    each.value.static_routes,
    [
      {
        destination_prefix = "0.0.0.0/0"
        gateway_id         = local.subnet_default_gateway[each.key].gateway
      }
    ]
  )
  timeouts = each.value.timeouts
}

module "subnets" {
  source         = "./subnet"
  for_each       = var.subnets
  name           = try(each.value.name, each.key)
  description    = each.value.description
  labels         = each.value.labels
  zone           = each.value.zone
  ip_cidr_ranges = [each.value.ip_cidr_range]
  dhcp_options   = each.value.dhcp_options
  network_id     = module.vpc.this.id
  folder_id      = module.vpc.this.folder_id
  route_table_id = module.route_tables[each.key].this.id
  timeouts       = each.value.timeouts
}

module "ip_addresses" {
  source                = "./ip_address"
  for_each              = var.ip_addresses
  name                  = try(each.value.name, null)
  description           = each.value.description
  folder_id             = module.vpc.this.folder_id
  labels                = each.value.labels
  deletion_protection   = each.value.deletion_protection
  dns_record            = each.value.dns_record
  external_ipv4_address = each.value.external_ipv4_address
  timeouts              = each.value.timeouts
}

module "firewall_rules" {
  source     = "./security_group"
  for_each   = merge(local.firewall_rules_egress, local.firewall_rules_ingress)
  name       = each.value.name
  folder_id  = each.value.folder_id
  network_id = each.value.network_id
  ingress    = each.value.ingress
  egress     = each.value.egress
}
