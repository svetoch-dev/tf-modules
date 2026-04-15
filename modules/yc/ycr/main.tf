resource "yandex_container_registry" "registry" {
  name      = var.name
  folder_id = var.folder_id
}

resource "yandex_container_registry_iam_binding" "pullers" {
  count       = length(var.pullers) > 0 ? 1 : 0
  registry_id = yandex_container_registry.registry.id
  role        = "container-registry.images.puller"
  members     = var.pullers
}

resource "yandex_container_registry_iam_binding" "pushers" {
  count       = length(var.pushers) > 0 ? 1 : 0
  registry_id = yandex_container_registry.registry.id
  role        = "container-registry.images.pusher"
  members     = var.pushers
}

resource "yandex_container_registry_ip_permission" "allow" {
  count       = var.ip_permissions != null && (length(var.ip_permissions.push) > 0 || length(var.ip_permissions.pull) > 0) ? 1 : 0
  registry_id = yandex_container_registry.registry.id
  push        = var.ip_permissions.push
  pull        = var.ip_permissions.pull
}
