module "api_tokens" {
  source     = "./api_token"
  for_each   = var.api_tokens
  name       = each.value.name
  expires_on = try(each.value.expires_on, null)
  not_before = try(each.value.not_before, null)
  policies   = each.value.policies
}

module "pages" {
  source             = "./pages"
  for_each           = var.pages
  account_id         = each.value.account_id
  name               = each.value.name
  production_branch  = each.value.production_branch
  git_source         = each.value.git_source
  build_config       = each.value.build_config
  deployment_configs = try(each.value.deployment_configs, null)
}

modules "dns_zones" {
  source   = "./dns_zone"
  for_each = var.dns_zones
  zone     = each.value.zone
  records  = each.value.records
}
