output "cis" {
  description = "CI configs variables"
  value       = module.gitlab.repositories
  sensitive   = true
}
