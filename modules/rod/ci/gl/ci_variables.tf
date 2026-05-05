locals {
  cis = merge(
    {
      infra = {
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
        name = ci_obj.repo_name
        org  = ci_obj.repo_group
        vars = merge(
          {
            for k, v in {
              cd_branch = ci_obj.cd_branch
              cd_file   = ci_obj.cd_file
              cd_path   = ci_obj.cd_path
              } : k => {
              name  = upper(k)
              value = v
            }
            if v != null && v != ""
          },
          {
            for var in ci_obj.vars : var.name => {
              name  = var.name
              value = var.value
            }
          }
        )
        secrets = {
          for secret in ci_obj.secrets : secret.name => {
            name       = secret.name
            text_value = secret.value
          }
        }
      }
    }
  )
}
