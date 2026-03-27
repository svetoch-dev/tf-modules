resource "yandex_vpc_security_group" "this" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  network_id  = var.network_id
  labels      = var.labels

  dynamic "ingress" {
    for_each = var.ingress

    content {
      description       = try(ingress.value.description, null)
      from_port         = try(ingress.value.from_port, null)
      labels            = try(ingress.value.labels, null)
      port              = try(ingress.value.port, null)
      predefined_target = try(ingress.value.predefined_target, null)
      protocol          = ingress.value.protocol
      security_group_id = try(ingress.value.security_group_id, null)
      to_port           = try(ingress.value.to_port, null)
      v4_cidr_blocks    = try(ingress.value.v4_cidr_blocks, null)
      v6_cidr_blocks    = try(ingress.value.v6_cidr_blocks, null)
    }
  }

  dynamic "egress" {
    for_each = var.egress

    content {
      description       = try(egress.value.description, null)
      from_port         = try(egress.value.from_port, null)
      labels            = try(egress.value.labels, null)
      port              = try(egress.value.port, null)
      predefined_target = try(egress.value.predefined_target, null)
      protocol          = egress.value.protocol
      security_group_id = try(egress.value.security_group_id, null)
      to_port           = try(egress.value.to_port, null)
      v4_cidr_blocks    = try(egress.value.v4_cidr_blocks, null)
      v6_cidr_blocks    = try(egress.value.v6_cidr_blocks, null)
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
