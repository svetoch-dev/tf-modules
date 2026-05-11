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
      for ci_obj in var.ci_configs :
      "${ci_obj.env_short_name}_${ci_obj.ci_name}" => {
        name = ci_obj.repo.name
        org  = coalesce(ci_obj.repo.group, var.repo.group)
        vars = (
          {
            for var_name, var_obj in {
              registry_url = ci_obj.env_registry_url
              cd_branch    = ci_obj.cd.branch
              cd_file      = ci_obj.cd.file
              cd_tag_path  = ci_obj.cd.tag_path
              } : var_name => {
              name  = replace(upper("${ci_obj.env_short_name}_${var_name}"), "-", "_")
              value = var_obj
            }
            if var_obj != null && var_obj != ""
          }
        )
      }
    }
  )
}
