output "security_group" {
  value       = yandex_vpc_security_group.this
  description = "The Yandex Cloud security group created for this firewall rule."
}
