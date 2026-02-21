output "this" {
  value = {
    token = data.yandex_client_config.client.iam_token
  }
}
