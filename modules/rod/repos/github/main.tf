provider "github" {
  owner = var.repo.group
}

module "repos" {
  source       = "../../../github"
  repositories = local.repos_merged
}
