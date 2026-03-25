locals {
  allow_entries = flatten(
    [
      for protocol, protocol_obj in var.rule.allow :
      [
        for port in protocol_obj.ports :
        {
          protocol = upper(protocol == "all" ? "ANY" : protocol)
          port     = port
        }
      ]
    ]
  )
}

resource "yandex_vpc_security_group" "this" {
  name        = var.name
  description = var.rule.description
  folder_id   = var.folder_id
  network_id  = var.network_id

  dynamic "ingress" {
    for_each = upper(var.rule.direction) == "INGRESS" ? local.allow_entries : []

    content {
      protocol       = ingress.value.protocol
      v4_cidr_blocks = var.rule.source_ranges
      port           = ingress.value.port
    }
  }

  dynamic "egress" {
    for_each = upper(var.rule.direction) == "EGRESS" ? local.allow_entries : []

    content {
      protocol       = ingress.value.protocol
      v4_cidr_blocks = var.rule.source_ranges
      port           = ingress.value.port
    }
  }
}
