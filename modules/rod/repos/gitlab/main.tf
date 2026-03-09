provider "gitlab" {
}

module "gitlab" {
  source       = "../../../gitlab"
  repositories = local.repos_merged
}
