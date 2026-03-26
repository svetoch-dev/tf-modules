resource "yandex_resourcemanager_folder_iam_member" "this" {
  for_each  = toset(var.members)
  folder_id = var.folder_id
  role      = var.role
  member    = each.value
}
