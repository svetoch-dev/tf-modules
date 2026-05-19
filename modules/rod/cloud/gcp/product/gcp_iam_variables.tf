locals {
  gcp_iam = {
    roles = {
      owners = {
        role = "roles/owner"
        members = concat(
          [
            for user_name, user_obj in var.env.users :
            "user:${user_obj.name}"
            if contains(user_obj.roles, "owner")
          ],
          [
            "serviceAccount:runner@${var.int_env.cloud.id}.iam.gserviceaccount.com"
          ]
        )
      }
    }
  }
}
