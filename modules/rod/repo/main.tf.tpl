provider "github" {
  owner = var.ci.group
}

module "github" {
  source = "../../github"
  #Use for_each so that resources path prefix
  #would be module.github["this"]
#  for_each = var.ci.type == "gha" ? {
#    "this" = ""
#  } : {}
  count        = var.ci.type == "gha" ? 1 : 0

  repositories = local.repositories_merged
}
