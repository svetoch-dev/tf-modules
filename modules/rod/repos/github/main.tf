provider "github" {
  owner = var.repo.group
}

module "github" {
  source       = "../../../github"
  repositories = local.repos_merged
}
