locals {
  member = lookup(
    {
      "serviceAccountName" = length(data.yandex_iam_service_account.sa[*]) > 0 ? "serviceAccount:${data.yandex_iam_service_account.sa[0].id}" : ""
      "userAccountName"    = length(data.yandex_iam_user.user[*]) > 0 ? "userAccount:${data.yandex_iam_user.user[0].id}" : ""
    },
    split(":", var.member)[0],
    var.member
  )

}

data "yandex_iam_service_account" "sa" {
  count = strcontains(var.member, "serviceAccountName:") ? 1 : 0
  name  = trimprefix(var.member, "serviceAccountName:")
}

data "yandex_iam_user" "user" {
  count = strcontains(var.member, "userAccountName:") ? 1 : 0
  login = trimprefix(var.member, "userAccountName:")
}
