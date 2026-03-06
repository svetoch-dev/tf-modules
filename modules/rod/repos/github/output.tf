output "repos" {
  description = "Repositories"
  value       = module.repos.repositories
  sensitive   = true
}
