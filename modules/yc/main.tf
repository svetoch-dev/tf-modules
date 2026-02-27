#Will be deleted after the first module
resource "yandex_iam_service_account" "dummy" {
  name        = "dummy"
  description = "dummy service account for testing purposes"
}
