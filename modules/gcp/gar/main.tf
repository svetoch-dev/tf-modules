resource "google_artifact_registry_repository" "registry" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "STANDARD_REPOSITORY"
  }
  description   = each.value.description
  mode          = "STANDARD_REPOSITORY"
  location      = var.location
  format        = each.value.format
  repository_id = each.key
}

resource "google_artifact_registry_repository" "virtual_registry" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "VIRTUAL_REPOSITORY"
  }
  description   = each.value.description
  mode          = "VIRTUAL_REPOSITORY"
  location      = var.location
  format        = each.value.format
  repository_id = each.key
  virtual_repository_config {
    upstream_policies {
      id         = each.value.upstream_repo
      repository = google_artifact_registry_repository.registry[each.value.upstream_repo].id
      priority   = each.value.priority
    }
  }
  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_artifact_registry_repository_iam_binding" "pullers" {
  for_each   = var.registries
  location   = var.location
  repository = google_artifact_registry_repository.registry[each.key].name
  role       = "roles/artifactregistry.reader"
  members    = var.pullers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.registry, google_artifact_registry_repository.virtual_registry]
}

resource "google_artifact_registry_repository_iam_binding" "pushers" {
  for_each   = var.registries
  location   = var.location
  repository = google_artifact_registry_repository.registry[each.key].name
  role       = "roles/artifactregistry.writer"
  members    = var.pushers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.registry, google_artifact_registry_repository.virtual_registry]
}
