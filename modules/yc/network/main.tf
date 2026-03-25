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

module "nat_gws" {
  source    = "./nat"
  for_each  = var.nat_gws
  name      = try(each.value.name, each.key)
  folder_id = module.vpc.this.folder_id
}

module "route_tables" {
  source     = "./route_table"
  for_each   = var.subnets
  name       = try(each.value.name, each.key)
  folder_id  = module.vpc.this.folder_id
  network_id = module.vpc.this.id
  static_routes = concat(
    each.value.static_routes,
    [
      {
        destination_prefix = "0.0.0.0/0"
        gateway_id         = local.subnet_default_gateway[each.key].gateway
      }
    ]
  )
}

module "subnets" {
  source         = "./subnet"
  for_each       = var.subnets
  name           = try(each.value.name, each.key)
  description    = each.value.description
  zone           = each.value.zone
  ip_cidr_ranges = [each.value.ip_cidr_range]
  network_id     = module.vpc.this.id
  folder_id      = module.vpc.this.folder_id
  route_table_id = module.route_tables[each.key].this.id
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
  name       = try(each.value.name, each.key)
  folder_id  = module.vpc.this.folder_id
  network_id = module.vpc.this.id
  rule       = each.value
}
