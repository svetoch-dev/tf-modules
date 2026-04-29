locals {
  yc_dns_zones = {
    tostring(var.env.name) = {
      name = var.env.name
      zone = var.env.dns.domain
    }
  }
}
