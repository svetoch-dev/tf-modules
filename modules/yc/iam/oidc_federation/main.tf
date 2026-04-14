resource "yandex_iam_workload_identity_oidc_federation" "this" {
  name        = var.name
  issuer      = var.issuer
  jwks_url    = var.jwks_url
  folder_id   = var.folder_id
  audiences   = var.audiences
  description = var.description
  disabled    = var.disabled
  labels      = var.labels

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
