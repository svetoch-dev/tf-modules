resource "cloudflare_zone" "this" {
  account = {
    id = var.zone.account_id
  }
  type = var.zone.type
  zone = var.zone.zone
}

resource "cloudflare_dns_record" "records" {
  zone_id  = cloudflare_zone.this.id
  for_each = var.records
  name     = each.value.name
  type     = each.value.type
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  content  = each.value.value
  priority = each.value.priority
}
