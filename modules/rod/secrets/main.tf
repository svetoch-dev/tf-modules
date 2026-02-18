module "secrets" {
  source = "../../secrets"
  #Use for_each so that resources path prefix
  #would be module.gcp["this"]
  for_each = var.env.cloud.name == "gcp" ? {
    "this" = ""
  } : {}

  secrets = local.secrets_merged
}
