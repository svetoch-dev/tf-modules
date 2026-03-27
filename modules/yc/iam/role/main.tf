resource "yandex_resourcemanager_folder_iam_member" "this" {
  for_each  = toset(module.members.converted)
  folder_id = var.folder_id
  role      = var.role
  member    = each.value
}

module "members" {
  source  = "../members"
  members = var.members
}
