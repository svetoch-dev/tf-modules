resource "yandex_container_registry" "this" {
  name      = var.name
  folder_id = var.folder_id
  labels    = var.labels

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
      read   = timeouts.value.read
    }
  }
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

  dynamic "timeouts" {
    for_each = var.ip_permissions.default_timeouts != null ? [var.ip_permissions.default_timeouts] : []
    content {
      default = timeouts.value
    }
  }
}

resource "yandex_container_repository" "this" {
  for_each = var.repositories
  name     = each.value.name == null ? "${yandex_container_registry.this.id}/${each.key}" : "${yandex_container_registry.this.id}/${each.value.name}"

  dynamic "timeouts" {
    for_each = each.value.timeouts == null ? [] : [each.value.timeouts]

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
      read   = timeouts.value.read
    }
  }
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

resource "yandex_container_repository_lifecycle_policy" "this" {
  for_each = {
    for name, obj in var.repositories : name => obj
    if obj.lifecycle_policy != null
  }
  name          = each.value.lifecycle_policy.name != null ? each.value.lifecycle_policy.name : "${each.key}-policy"
  status        = each.value.lifecycle_policy.status
  repository_id = yandex_container_repository.this[each.key].id
  description   = each.value.lifecycle_policy.description

  dynamic "rule" {
    for_each = each.value.lifecycle_policy.rule != null ? [each.value.lifecycle_policy.rule] : []
    content {
      description   = rule.value.description != null ? rule.value.description : "${each.key} lifecycle policy rule"
      expire_period = rule.value.expire_period
      retained_top  = rule.value.retained_top
      tag_regexp    = rule.value.tag_regexp
      untagged      = rule.value.untagged
    }
  }

  dynamic "timeouts" {
    for_each = each.value.lifecycle_policy.default_timeouts != null ? [each.value.lifecycle_policy.default_timeouts] : []
    content {
      default = timeouts.value
    }
  }
}
