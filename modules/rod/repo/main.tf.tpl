provider "github" {
  owner = var.ci.group
  token = var.token
}

module "github" {
  source = "../../github"
  #Use for_each so that resources path prefix
  #would be module.github["this"]
  for_each = var.ci.type == "gha" ? {
    "this" = ""
  } : {}

  repositories = local.repositories_merged
}
