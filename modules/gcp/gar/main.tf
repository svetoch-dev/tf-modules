resource "google_artifact_registry_repository" "registry" {
  description   = var.description
  mode          = var.mode
  location      = var.location
  format        = var.format
  repository_id = var.repository_id
  dynamic "remote_repository_config" {
    for_each = var.remote_repository[*]
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
  dynamic "virtual_repository_config" {
    for_each = var.virtual_repository[*]
    content {
      dynamic "upstream_policies" {
        for_each = virtual_repository_config.value.upstream_repositories
        content {
          id         = upstream_policies.key
          repository = upstream_policies.value.repository
          priority   = upstream_policies.value.priority
        }
      }
    }
  }
}

resource "google_artifact_registry_repository_iam_binding" "readers" {
  location   = var.location
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.reader"
  members    = var.readers
  depends_on = [google_artifact_registry_repository.registry]
}

resource "google_artifact_registry_repository_iam_binding" "writers" {
  location   = var.location
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.writer"
  members    = var.writers
  depends_on = [google_artifact_registry_repository.registry]
}
