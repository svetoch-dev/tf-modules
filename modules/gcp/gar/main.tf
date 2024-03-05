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
    dynamic "upstream_policies" {
      for_each = each.value.upstream_repositories
      content {
        id         = upstream_policies.key
        repository = google_artifact_registry_repository.registry[upstream_policies.key].id
        priority   = upstream_policies.value.priority
      }
    }
  }
  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_artifact_registry_repository" "remote_registry" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "REMOTE_REPOSITORY"
  }
  description   = each.value.description
  mode          = "REMOTE_REPOSITORY"
  location      = var.location
  format        = each.value.format
  repository_id = each.key
  remote_repository_config {
    description = each.value.remote_repository.description
    dynamic "docker_repository" {
      for_each = each.value.remote_repository.docker_repository
      content {
        public_repository = docker_repository.value
      }
    }
  }
}

resource "google_artifact_registry_repository_iam_binding" "readers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "STANDARD_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.registry[each.key].name
  role       = "roles/artifactregistry.reader"
  members    = var.readers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_artifact_registry_repository_iam_binding" "writers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "STANDARD_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.registry[each.key].name
  role       = "roles/artifactregistry.writer"
  members    = var.writers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_artifact_registry_repository_iam_binding" "vr_readers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "VIRTUAL_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.virtual_registry[each.key].name
  role       = "roles/artifactregistry.reader"
  members    = var.readers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.virtual_registry]
}

resource "google_artifact_registry_repository_iam_binding" "vr_writers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "VIRTUAL_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.virtual_registry[each.key].name
  role       = "roles/artifactregistry.writer"
  members    = var.writers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.virtual_registry]
}

resource "google_artifact_registry_repository_iam_binding" "rr_readers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "REMOTE_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.remote_registry[each.key].name
  role       = "roles/artifactregistry.reader"
  members    = var.readers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.remote_registry]
}

resource "google_artifact_registry_repository_iam_binding" "rr_writers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode == "REMOTE_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.remote_registry[each.key].name
  role       = "roles/artifactregistry.writer"
  members    = var.writers
  project    = var.project_id
  depends_on = [google_artifact_registry_repository.remote_registry]
}
