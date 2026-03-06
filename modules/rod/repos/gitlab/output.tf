output "repos" {
  description = "repositories"
  value = merge(
    try(module.github_repos[0].repositories, {}),
    try(module.gitlab_repos[0].repositories, {})
  )
  sensitive = true
}
