resource "yandex_resourcemanager_folder_iam_member" "this" {
  for_each  = toset(var.members)
  folder_id = var.folder_id
  role      = var.role
  member    = module.members[each.value].converted
}

module "members" {
  source = "../member"
  for_each = toset(
    [
      for member in var.members :
      member
    ]
  )
  member = each.value
}
