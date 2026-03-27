resource "yandex_vpc_address" "this" {
  name                = var.name
  description         = var.description
  folder_id           = var.folder_id
  labels              = var.labels
  deletion_protection = var.deletion_protection

  external_ipv4_address {
    zone_id                  = try(var.external_ipv4_address.zone_id, null)
    ddos_protection_provider = try(var.external_ipv4_address.ddos_protection_provider, null)
    outgoing_smtp_capability = try(var.external_ipv4_address.outgoing_smtp_capability, null)
  }

  dynamic "dns_record" {
    for_each = var.dns_record

    content {
      dns_zone_id = dns_record.value.dns_zone_id
      fqdn        = dns_record.value.fqdn
      ptr         = try(dns_record.value.ptr, null)
      ttl         = try(dns_record.value.ttl, null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
