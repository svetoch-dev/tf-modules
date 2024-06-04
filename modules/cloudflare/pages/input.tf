variable "account_id" {
  description = "Cloudflare account id"
  type        = string
}

variable "name" {
  description = "Cloudflare pages project name"
  type        = string
}

variable "production_branch" {
  description = "production branch name"
  type        = string
}


variable "git_source" {
  description = "Git source configuration"
  type = object(
    {
      type                          = string
      owner                         = string
      repo_name                     = string
      pr_comments_enabled           = optional(bool, true)
      deployments_enabled           = optional(bool, true)
      production_deployment_enabled = optional(bool, true)
      preview_deployment_setting    = optional(string, "all")
      preview_branch_includes       = optional(list(string))
      preview_branch_excludes       = optional(list(string))
    }
  )
}

variable "build_config" {
  description = "Build configuration"
  type = object(
    {
      build_command       = string
      destination_dir     = string
      root_dir            = optional(string, "")
      web_analytics_tag   = optional(string)
      web_analytics_token = optional(string)
    }
  )
}

variable "deployment_configs" {
  description = "Deployment configuration"
  type = object(
    {
      preview = optional(
        object(
          {
            env                       = optional(map(string))
            secret_env                = optional(map(string))
            kv_namespaces             = optional(map(string))
            durable_object_namespaces = optional(map(string))
            r2_buckets                = optional(map(string))
            d1_databases              = optional(map(string))
            compatibility_date        = optional(string)
            compatibility_flags       = optional(list(string))
          }
        )
      )
      production = optional(
        object(
          {
            env                       = optional(map(string))
            secret_env                = optional(map(string))
            kv_namespaces             = optional(map(string))
            durable_object_namespaces = optional(map(string))
            r2_buckets                = optional(map(string))
            d1_databases              = optional(map(string))
            compatibility_date        = optional(string)
            compatibility_flags       = optional(list(string))
          }
        )
      )
    }
  )
  default = null
}
