locals {
  app_repos = toset([
    for app in var.app_env_ci_configs : {
      name = app.repo.name
      org  = coalesce(app.repo.group, var.repo.group)
    }
  ])

  cis = merge(
    {
      infrastructure = {
        name = var.repo.name
        org  = var.repo.group
        vars = {
          runner_name = {
            name  = "RUNNER_NAME"
            value = "gha-runner-${var.env.cloud.name}-${var.env.short_name}"
          }
          bazelisk_image = {
            name  = "BAZELISK_IMAGE"
            value = var.bazelisk_image
          }
        }
      }
    },
    {
      for repo in local.app_repos :
      repo.name => {
        name = repo.name
        org  = repo.org
        vars = {
          kaniko_image = {
            name  = "KANIKO_IMAGE"
            value = "ghcr.io/osscontainertools/kaniko:v1.29.1-debug@sha256:ebc38a988e5aa1aaea99240e931aeeeff9d8e6bb5a0bd0e00eaf79973bf0a773"
          }
          ci_image = {
            name  = "CI_IMAGE"
            value = var.ci_image
          }
          runner_name = {
            name  = "RUNNER_NAME"
            value = "gha-runner-app-${var.env.cloud.name}-${var.env.short_name}"
          }
          infra_repo_url = {
            name  = "INFRA_REPO_URL"
            value = "git@github.com:${var.repo.group}/${var.repo.name}.git"
          }
        }
      }
    },
    {
      for ci_obj in var.app_env_ci_configs :
      "${ci_obj.env.short_name}_${ci_obj.app_name}" => {
        name = ci_obj.repo.name
        org  = coalesce(ci_obj.repo.group, var.repo.group)
        vars = {
          for var_name, var_obj in {
            registry     = ci_obj.env.registry_url == null ? null : split("/", ci_obj.env.registry_url)[0]
            registry_url = ci_obj.env.registry_url
            cd_branch    = ci_obj.cd.branch
            cd_file      = ci_obj.cd.file
            cd_tag_path  = ci_obj.cd.tag_path
          } :
          var_name => {
            name  = replace(upper("${ci_obj.env.short_name}_${var_name}"), "-", "_")
            value = var_obj
          }
          if var_obj != null
        }
      }
    }
  )
}
