locals {
  repos_merged = provider::deepmerge::mergo(local.repos, var.overrides.repos)
}
