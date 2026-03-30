locals {
  members = concat(
    #First form list of all members without serviceAccountName: and userAccountName:
    [
      for member in var.members :
      member
      if !strcontains(member, "serviceAccountName:") && !strcontains(member, "userAccountName:")
    ],
    [
      for member in var.members :
      "serviceAccount:${data.yandex_iam_service_account.sa[trimprefix(member, "serviceAccountName:")].id}"
      if strcontains(member, "serviceAccountName:")
    ],
    [
      for member in var.members :
      "userAccount:${data.yandex_iam_user.user[trimprefix(member, "userAccountName:")].id}"
      if strcontains(member, "userAccountName:")
    ]
  )
}

data "yandex_iam_service_account" "sa" {
  for_each = toset(
    [
      for member in var.members :
      trimprefix(member, "serviceAccountName:")
      if strcontains(member, "serviceAccountName:")
    ]
  )
  name = each.key
}

data "yandex_iam_user" "user" {
  for_each = toset(
    [
      for member in var.members :
      trimprefix(member, "userAccountName:")
      if strcontains(member, "userAccountName:")
    ]
  )
  login = each.key
}
