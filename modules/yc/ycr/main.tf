resource "yandex_container_registry" "this" {
  name      = var.name
  folder_id = var.folder_id
}

resource "yandex_container_registry_iam_binding" "pullers" {
  count       = length(var.readers) > 0 ? 1 : 0
  registry_id = yandex_container_registry.this.id
  role        = "container-registry.images.puller"
  members     = var.readers
}

resource "yandex_container_registry_iam_binding" "pushers" {
  count       = length(var.writers) > 0 ? 1 : 0
  registry_id = yandex_container_registry.this.id
  role        = "container-registry.images.pusher"
  members     = var.writers
}

resource "yandex_container_registry_ip_permission" "allow" {
  count       = var.ip_permissions != null && (length(var.ip_permissions.write) > 0 || length(var.ip_permissions.read) > 0) ? 1 : 0
  registry_id = yandex_container_registry.this.id
  push        = var.ip_permissions.write
  pull        = var.ip_permissions.read
}

resource "yandex_container_repository" "this" {
  for_each = var.repositories
  name     = "${yandex_container_registry.this.id}/${each.key}"
}

resource "yandex_container_repository_iam_binding" "pullers" {
  for_each = {
    for name, obj in var.repositories : name => obj
    if length(obj.readers) > 0
  }
  repository_id = yandex_container_repository.this[each.key].id
  role          = "container-registry.images.puller"
  members       = each.value.readers
}

resource "yandex_container_repository_iam_binding" "pushers" {
  for_each = {
    for name, obj in var.repositories : name => obj
    if length(obj.writers) > 0
  }
  repository_id = yandex_container_repository.this[each.key].id
  role          = "container-registry.images.pusher"
  members       = each.value.writers
}
