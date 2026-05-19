locals {
  users = {
    owners = [
      for user_name, user_obj in var.env.users :
      "userAccountName:${user_obj.name}"
      if contains(user_obj.roles, "owner")
    ]
  }
  yc_iam = {
    roles = {
      owners = {
        role = "admin"
        members = concat(
          local.users.owners,
          [
            "serviceAccountName:${var.int_env.cloud.folder_id}:runner-${var.int_env.short_name}"
          ]
        )
      }
    }
  }
}
