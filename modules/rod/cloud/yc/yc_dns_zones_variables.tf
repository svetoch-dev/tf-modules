locals {
  yc_dns_zones = {
    tostring(var.env.name) = {
      name = var.env.name
      zone = format("%s.%s.", var.env.short_name, var.company.domain)
    }
  }
}
