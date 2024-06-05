resource "cloudflare_pages_project" "this" {
  account_id        = var.account_id
  name              = var.name
  production_branch = var.production_branch


  dynamic "source" {
    for_each = var.git_source != null ? { "main" = var.git_source } : {}
    content {
      type = source.value.type
      config {
        owner                         = source.value.owner
        repo_name                     = source.value.repo_name
        production_branch             = var.production_branch
        pr_comments_enabled           = source.value.pr_comments_enabled
        deployments_enabled           = source.value.deployments_enabled
        production_deployment_enabled = source.value.production_deployment_enabled
        preview_deployment_setting    = source.value.preview_deployment_setting
        preview_branch_includes       = source.value.preview_branch_includes
        preview_branch_excludes       = source.value.preview_branch_excludes
      }
    }
  }

  dynamic "build_config" {
    for_each = var.build_config != null ? { "main" = var.build_config } : {}
    content {
      build_command       = build_config.value.build_command
      destination_dir     = build_config.value.destination_dir
      root_dir            = build_config.value.root_dir
      web_analytics_tag   = build_config.value.web_analytics_tag
      web_analytics_token = build_config.value.web_analytics_token
    }
  }

  dynamic "deployment_configs" {
    for_each = var.deployment_configs != null ? { "main" = var.deployment_configs } : {}
    content {
      dynamic "preview" {
        for_each = deployment_configs.value.preview != null ? { "main" = deployment_configs.value.preview } : {}
        content {
          environment_variables     = preview.value.env
          secrets                   = preview.value.secret_env
          kv_namespaces             = preview.value.kv_namespaces
          durable_object_namespaces = preview.value.durable_object_namespaces
          r2_buckets                = preview.value.r2_buckets
          d1_databases              = preview.value.d1_databases
          compatibility_date        = preview.value.compatibility_date
          compatibility_flags       = preview.value.compatibility_flags
        }
      }
      dynamic "production" {
        for_each = deployment_configs.value.production != null ? { "main" = deployment_configs.value.production } : {}
        content {
          environment_variables     = production.value.env
          secrets                   = production.value.secret_env
          kv_namespaces             = production.value.kv_namespaces
          durable_object_namespaces = production.value.durable_object_namespaces
          r2_buckets                = production.value.r2_buckets
          d1_databases              = production.value.d1_databases
          compatibility_date        = production.value.compatibility_date
          compatibility_flags       = production.value.compatibility_flags
        }
      }
    }
  }
}
