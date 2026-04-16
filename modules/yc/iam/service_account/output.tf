output "this" {
  description = "Service account object"
  value = merge(
    yandex_iam_service_account.this,
    {
      key                   = var.generate_key ? yandex_iam_service_account_key.this[0].private_key : ""
      federated_credentials = yandex_iam_workload_identity_federated_credential.this
    }
  )
}
