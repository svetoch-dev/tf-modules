output "this" {
  value = merge(
    google_artifact_registry_repository.registry,
    {
      endpoint = local.endpoint
    }
  )
}
