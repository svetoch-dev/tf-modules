output "ci_vars" {
  description = "CI variables"
  value       = module.github.repositories
  sensitive   = true
}
