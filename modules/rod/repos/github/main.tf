provider "github" {
  owner = var.repo.group
  token = var.token
}

module "github" {
  source       = "../../../github"
  repositories = local.repos_merged
}
