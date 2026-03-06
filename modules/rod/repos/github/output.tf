output "repos" {
  description = "repositories"
  value       = module.repos.repositories
  sensitive   = true
}
