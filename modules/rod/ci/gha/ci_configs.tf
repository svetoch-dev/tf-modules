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
      for ci_obj in var.ci_configs : ci_obj.ci_name => {
        name = ci_obj.repo.name
        org  = ci_obj.repo.group != "" ? ci_obj.repo.group : var.repo.group
        vars = (
          {
            for k, v in {
              registry_url = ci_obj.env_registry_url
              cd_branch    = ci_obj.cd.branch
              cd_file      = ci_obj.cd.file
              cd_path      = ci_obj.cd.tag_path
              } : k => {
              name  = replace(upper("${k}_${ci_obj.env_short_name}"), "-", "_")
              value = v
            }
            if v != null && v != ""
          }
        )
      }
    }
  )
}
