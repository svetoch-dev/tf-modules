output "repo" {
  description = "Repositories"
  value       = module.gitlab.repositories
  sensitive   = true
}
