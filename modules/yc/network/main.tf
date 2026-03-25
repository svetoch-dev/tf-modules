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
  labels       = var.vpc.labels
  timeouts     = var.vpc.timeouts
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
  source     = "./firewall_rule"
  for_each   = var.firewall_rules
  name       = try(each.value.name, each.key)
  folder_id  = module.vpc.this.folder_id
  network_id = module.vpc.this.id
  rule       = each.value
}
