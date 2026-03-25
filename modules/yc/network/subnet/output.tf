output "subnet" {
  value       = yandex_vpc_subnet.this
  description = "The subnet resource."
}

output "id" {
  value       = yandex_vpc_subnet.this.id
  description = "The subnet ID."
}

output "name" {
  value       = yandex_vpc_subnet.this.name
  description = "The subnet name."
}
