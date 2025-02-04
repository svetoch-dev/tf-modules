resource "cloudflare_zone" "this" {
  account_id = var.zone.account_id
  type       = var.zone.type
  zone       = var.zone.name
}

resource "cloudflare_record" "records" {
  for_each = {
    for record in var.records :
    #We need to include record.value in resource name
    #for cases like with NS records. They share same
    #name and same type but have different values
    "${record.name}-${record.type}-${record.value}" => record
    if record.type != "SRV"
  }
  zone_id  = cloudflare_zone.this.id
  name     = each.value.name
  type     = each.value.type
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  content  = each.value.value
  priority = each.value.priority
}

resource "cloudflare_record" "records_srv" {
  for_each = {
    for record in var.records :
    "${record.name}-${record.type}" => record
    if record.type == "SRV"
  }
  zone_id = cloudflare_zone.this.id
  name    = each.value.name
  type    = each.value.type
  data {
    service  = each.value.data.service
    proto    = each.value.data.proto
    port     = each.value.data.port
    name     = each.value.data.name
    weight   = each.value.data.weight
    priority = each.value.data.priority
    target   = each.value.data.target
  }
}
