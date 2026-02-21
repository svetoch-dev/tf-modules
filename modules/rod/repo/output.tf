/*
output "repos" {
  description = "github repositories"
  value       = module.github.repositories
  sensitive   = true
}
*/
output "debug_merged" {
  value = local.repositories_merged
}
