output "ci_vars" {
  description = "CI variables"
  value       = module.gitlab.repositories
  sensitive   = true
}
