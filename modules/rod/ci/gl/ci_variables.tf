locals {
  cis = merge(
    {
      infrastructure = {
        name = var.repo.name
        org  = var.repo.group
        vars = {
          bazelisk_image = {
            name  = "BAZELISK_IMAGE"
            value = var.bazelisk_image
          }
        }
      }
    },
    {
      for ci_obj in var.ci_vars : ci_obj.ci_name => {
        name = ci_obj.ci_data.repo_name
        org  = ci_obj.ci_data.repo_group
        vars = merge(
          {
            for k, v in {
              cd_branch = ci_obj.ci_data.cd_branch
              cd_file   = ci_obj.ci_data.cd_file
              cd_path   = ci_obj.ci_data.cd_path
              } : k => {
              name  = replace(upper("${k}_${ci_obj.env_short_name}"), "-", "_")
              value = v
            }
            if v != null && v != ""
          },
          {
            for var in ci_obj.ci_data.vars : var.name => {
              name  = replace(upper("${var.name}_${ci_obj.env_short_name}"), "-", "_")
              value = var.value
            }
          }
        )
        secrets = {
          for secret in ci_obj.ci_data.secrets : secret.name => {
            name       = replace(upper("${secret.name}_${ci_obj.env_short_name}"), "-", "_")
            text_value = secret.value
          }
        }
      }
    }
  )
}
