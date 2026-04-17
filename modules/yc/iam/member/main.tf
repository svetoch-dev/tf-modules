locals {
  member_data = split(":", var.member)

  member = lookup(
    {
      "serviceAccountName" = length(data.yandex_iam_service_account.sa[*]) > 0 ? "serviceAccount:${data.yandex_iam_service_account.sa[0].id}" : ""
      "userAccountName"    = length(data.yandex_iam_user.user[*]) > 0 ? "userAccount:${data.yandex_iam_user.user[0].id}" : ""
    },
    local.member_data[0],
    var.member
  )
}


data "yandex_iam_service_account" "sa" {
  count = local.member_data[0] == "serviceAccountName" ? 1 : 0
  name  = local.member_data[length(local.member_data) - 1]
  #if var.member str is serviceAccountName:<folder_id>:<sa_name>
  #use <folder_id> else use provider folder id
  folder_id = length(local.member_data) == 3 ? local.member_data[1] : null
}

data "yandex_iam_user" "user" {
  count = local.member_data[0] == "userAccountName" ? 1 : 0
  login = local.member_data[length(local.member_data) - 1]
}
