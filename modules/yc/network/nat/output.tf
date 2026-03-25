output "gateway" {
  value       = yandex_vpc_gateway.this
  description = "The NAT gateway resource."
}

output "id" {
  value       = yandex_vpc_gateway.this.id
  description = "The NAT gateway ID."
}

output "name" {
  value       = yandex_vpc_gateway.this.name
  description = "The NAT gateway name."
}
