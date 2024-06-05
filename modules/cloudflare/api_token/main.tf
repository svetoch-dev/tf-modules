resource "cloudflare_api_token" "this" {
  name = var.name

  dynamic "policy" {
    for_each = var.policies
    content {
      permission_groups = policy.value.permission_groups
      resources         = policy.value.resources
      effect            = policy.value.effect
    }
  }

  not_before = var.not_before
  expires_on = var.expires_on
}
