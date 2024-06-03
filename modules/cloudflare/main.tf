module "api_tokens" {
  source     = "./api_token"
  for_each   = var.api_tokens
  name       = each.value.name
  expires_on = try(each.value.expires_on, null)
  not_before = try(each.value.not_before, null)
  policies   = each.value.policies
}
