locals {
  yc_dns_zones = {
    tostring(var.env.name) = {
      name = var.env.name
      zone = format("%s.%s.", var.env.short_name, var.company.domain)
      records = [
        {
          name = "hui"
          type = "A"
          data = ["192.168.0.1"]

          ttl = 200
        }
      ]
    }
  }
}
