output "cis" {
  description = "CI configs variables"
  value       = module.github.repositories
  sensitive   = true
}
