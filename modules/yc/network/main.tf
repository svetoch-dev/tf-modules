locals {
  subnet_default_gateway = {
    for subnet_name, subnet_obj in var.subnets :
    sunet_name => merge(
      {
        for nat_gw_name, nat_gw_obj in var.nat_gws :
        gateway => module.nat[nat_gw_name].id
        if contains(nat_gw_obj.subnetworks, nat_gw_obj.name)
      },
      {
        for nat_gw_name, nat_gw_obj in var.nat_gws :
        gateway => module.nat[nat_gw_name].id
        if nat_gw_obj.source_subnetwork_ip_ranges_to_nat == "ALL_SUBNETWORKS_ALL_IP_RANGES"
      }
    )
  }
}

module "vpc" {
  source       = "./vpc"
  folder_id    = var.vpc.folder_id
  network_name = var.vpc.name
  description  = var.vpc.description
}

module "nat" {
  source    = "./nat"
  for_each  = var.nat_gws
  name      = each.value.name
  folder_id = module.vpc.this.folder_id
}

module "route_table" {
  source     = "./route_table"
  for_each   = var.subnets
  name       = each.value.name
  folder_id  = module.vpc.this.folder_id
  network_id = module.vpc.this.network_id
  static_routes = concat(
    each.value.static_routes,
    [
      {
        destination_prefix = "0.0.0.0/0"
        gateway_id         = local.subnet_default_gateway[each.value.name].gateway
      }
    ]
  )
}

module "subnet" {
  source         = "./subnet"
  for_each       = var.subnets
  name           = each.value.name
  description    = each.value.description
  zone           = each.value.zone
  ip_cidr_range  = each.value.ip_cidr_range
  network_id     = module.vpc.this.network_id
  folder_id      = module.vpc.this.folder_id
  route_table_id = module.route_table[each.key].this.id
}

resource "yandex_vpc_address" "ip_addresses" {
  for_each = var.ip_addresses

  name        = each.value.name
  description = each.value.description
  folder_id   = module.vpc.this.folder_id

  external_ipv4_address {
    zone_id = each.value.zone
  }
}

module "firewall_rules" {
  source     = "./firewall_rule"
  for_each   = var.firewall_rules
  name       = each.key
  folder_id  = module.vpc.this.folder_id
  network_id = module.vpc.this.network_id
  rule       = each.value
}
