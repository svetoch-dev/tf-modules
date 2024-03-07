resource "google_artifact_registry_repository" "registry" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode != "VIRTUAL_REPOSITORY"
  }
  description   = each.value.description
  mode          = each.value.mode
  location      = var.location
  format        = each.value.format
  repository_id = each.key
  dynamic "remote_repository_config" {
    for_each = each.value.remote_repository[*]
    content {
      description = remote_repository_config.value.description
      dynamic "docker_repository" {
        for_each = remote_repository_config.value.docker_repository[*]
        content {
          public_repository = docker_repository.value.public_repository
        }
      }
      dynamic "apt_repository" {
        for_each = remote_repository_config.value.apt_repository[*]
        content {
          public_repository {
            repository_base = apt_repository.value.repository_base
            repository_path = apt_repository.value.repository_path
          }
        }
      }
      dynamic "yum_repository" {
        for_each = remote_repository_config.value.yum_repository[*]
        content {
          public_repository {
            repository_base = yum_repository.value.repository_base
            repository_path = yum_repository.value.repository_path
          }
        }
      }
    }
  }
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

resource "google_artifact_registry_repository_iam_binding" "readers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode != "VIRTUAL_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.registry[each.key].name
  role       = "roles/artifactregistry.reader"
  members    = each.value.readers
  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_artifact_registry_repository_iam_binding" "writers" {
  for_each = {
    for name, obj in var.registries :
    name => obj
    if obj.mode != "VIRTUAL_REPOSITORY"
  }
  location   = var.location
  repository = google_artifact_registry_repository.registry[each.key].name
  role       = "roles/artifactregistry.writer"
  members    = each.value.writers
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
  members    = each.value.readers
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
  members    = each.value.writers
  depends_on = [google_artifact_registry_repository.virtual_registry]
}
