output "this" {
  value = {
    token = data.google_client_config.client.access_token
  }
}
