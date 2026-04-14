resource "yandex_container_registry" "registry" {
  count     = var.registry.create ? 1 : 0
  name      = var.name
  folder_id = var.folder_id
}

resource "yandex_container_registry_iam_binding" "pullers" {
  count       = length(var.pullers) > 0 ? 1 : 0
  registry_id = yandex_container_registry.registry[0].id
  role        = "container-registry.images.puller"
  members     = var.pullers
}

resource "yandex_container_registry_iam_binding" "pushers" {
  count       = length(var.pushers) > 0 ? 1 : 0
  registry_id = yandex_container_registry.registry[0].id
  role        = "container-registry.images.pusher"
  members     = var.pushers
}
