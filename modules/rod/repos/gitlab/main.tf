provider "gitlab" {
}

module "repos" {
  source       = "../../../gitlab"
  repositories = local.repos_merged
}
