resource "google_compute_firewall" "default" {
  for_each                = var.rules
  name                    = each.key
  network                 = var.network
  direction               = each.value.direction
  description             = each.value.description
  target_tags             = each.value.target_tags
  source_ranges           = try(each.value.source_ranges, [])
  source_tags             = try(each.value.source_tags, [])
  source_service_accounts = try(each.value.source_service_accounts, [])
  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.key
      ports    = allow.value["ports"]
    }
  }
  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.key
      ports    = deny.value["ports"]
    }
  }
}
