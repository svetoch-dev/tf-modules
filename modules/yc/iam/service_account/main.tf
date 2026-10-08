locals {
  sa_iam_members = flatten([
    for role, members in var.sa_iam_bindings : [
      for member in members : {
        key    = "${role}-${member}"
        role   = role
        member = member
      }
    ]
  ])
}

resource "yandex_iam_service_account" "this" {
  folder_id   = var.folder_id
  name        = var.name
  description = var.description
}

resource "yandex_iam_service_account_key" "this" {
  count              = var.generate_key ? 1 : 0
  service_account_id = yandex_iam_service_account.this.id
}

resource "yandex_iam_workload_identity_federated_credential" "this" {
  for_each = var.federated_credentials

  service_account_id  = yandex_iam_service_account.this.id
  federation_id       = each.value.federation_id
  external_subject_id = each.value.external_subject_id
}

resource "yandex_resourcemanager_folder_iam_member" "roles" {
  for_each  = toset(var.roles)
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.this.id}"

  depends_on = [
    yandex_iam_service_account.this
  ]
}

resource "yandex_iam_service_account_iam_member" "bindings" {
  for_each = {
    for binding in local.sa_iam_members :
    binding.key => binding
  }

  service_account_id = yandex_iam_service_account.this.id
  role               = each.value.role
  member             = each.value.member

  depends_on = [
    yandex_iam_service_account.this
  ]
}

resource "yandex_resourcemanager_cloud_iam_member" "cloud_roles" {
  for_each = toset(var.cloud_roles)

  cloud_id = var.cloud_id
  role     = each.value
  member   = "serviceAccount:${yandex_iam_service_account.this.id}"

  lifecycle {
    precondition {
      condition     = try(length(trimspace(var.cloud_id)) > 0, false)
      error_message = "Set cloud_id when service account cloud_roles are configured."
    }
  }
}

resource "yandex_organizationmanager_organization_iam_member" "organization_roles" {
  for_each = toset(var.organization_roles)

  organization_id = var.organization_id
  role            = each.value
  member          = "serviceAccount:${yandex_iam_service_account.this.id}"

  lifecycle {
    precondition {
      condition     = try(length(trimspace(var.organization_id)) > 0, false)
      error_message = "Set organization_id when service account organization_roles are configured."
    }
  }
}
