output "zone" {
  value       = module.zone.this
  description = "The DNS zone resource."
}

output "records" {
  value = {
    for record_name, record_obj in module.records :
    record_name => record_obj

  }
  description = "The DNS record set resources in input order."
}
