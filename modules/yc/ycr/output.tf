output "this" {
  value = merge(
    yandex_container_registry.this,
    {
      endpoint = local.endpoint
    }
  )
}
