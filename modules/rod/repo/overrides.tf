locals {
  repos_merged = provider::deepmerge::mergo(local.repositories, var.overrides.repositories)
}
