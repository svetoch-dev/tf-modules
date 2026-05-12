provider "gitlab" {
}

module "gitlab" {
  source       = "../../../gitlab"
  repositories = local.cis_merged
}
