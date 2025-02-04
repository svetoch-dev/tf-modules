output "zone" {
  value = cloudflare_zone.this
}

output "records" {
  value = {
    for record_name, record_obj in cloudflare_record.records :
    record_name => record_obj
  }
}
