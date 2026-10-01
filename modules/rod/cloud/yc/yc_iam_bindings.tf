// Vedro creates a temporary static S3 key on its own SA to empty versioned buckets on Delete.
resource "yandex_iam_service_account_iam_member" "vedro_access_key_admin" {
  service_account_id = module.yc.iam.service_accounts["vedro"].id
  role               = "iam.serviceAccounts.accessKeyAdmin"
  member             = "serviceAccount:${module.yc.iam.service_accounts["vedro"].id}"
}
