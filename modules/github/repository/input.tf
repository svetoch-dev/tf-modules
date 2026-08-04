variable "name" {
  description = "Repository name"
  type        = string
}

variable "repository" {
  description = "Repository settings"
  type = object(
    {
      create                      = bool
      description                 = optional(string)
      homepage_url                = optional(string)
      visibility                  = string
      archived                    = bool
      archive_on_destroy          = optional(bool)
      auto_init                   = optional(bool)
      gitignore_template          = optional(string)
      license_template            = optional(string)
      is_template                 = optional(bool)
      topics                      = optional(set(string))
      has_issues                  = optional(bool)
      has_projects                = optional(bool)
      has_wiki                    = optional(bool)
      has_discussions             = optional(bool)
      allow_auto_merge            = bool
      allow_merge_commit          = bool
      allow_rebase_merge          = bool
      allow_squash_merge          = bool
      merge_commit_title          = optional(string)
      merge_commit_message        = optional(string)
      squash_merge_commit_title   = optional(string)
      squash_merge_commit_message = optional(string)
      allow_update_branch         = optional(bool)
      delete_branch_on_merge      = bool
      web_commit_signoff_required = optional(bool)
    }
  )
}

variable "rulesets" {
  description = "Repository rulesets"
  type = map(
    object(
      {
        name        = string
        target      = string
        enforcement = string
        include     = list(string)
        exclude     = list(string)
        bypass_actors = list(
          object(
            {
              actor_id    = optional(number)
              actor_type  = string
              bypass_mode = string
            }
          )
        )
        rules = object(
          {
            creation                = bool
            update                  = bool
            deletion                = bool
            non_fast_forward        = bool
            required_linear_history = bool
            required_signatures     = bool
            pull_request = optional(
              object(
                {
                  dismiss_stale_reviews_on_push     = bool
                  require_code_owner_review         = bool
                  require_last_push_approval        = bool
                  required_approving_review_count   = number
                  required_review_thread_resolution = bool
                }
              )
            )
            required_status_checks = optional(
              object(
                {
                  strict = bool
                  checks = set(
                    object(
                      {
                        context        = string
                        integration_id = optional(number)
                      }
                    )
                  )
                }
              )
            )
          }
        )
      }
    )
  )
  default = {}
}

variable "webhooks" {
  description = "Repository webhooks"
  type = map(
    object(
      {
        url          = string
        events       = set(string)
        active       = bool
        content_type = string
        insecure_ssl = bool
        secret       = optional(string)
      }
    )
  )
  default = {}
}

variable "deploy_keys" {
  description = "Repository deploy keys"
  type = map(
    object(
      {
        name      = string
        key       = string
        read_only = bool
      }
    )
  )
  default = {}
}

variable "secrets" {
  description = "Repository action secrets"
  type = map(
    object(
      {
        name       = string
        text_value = string
      }
    )
  )
  default = {}
}

variable "vars" {
  description = "Repository action variables"
  type = map(
    object(
      {
        name  = string
        value = string
      }
    )
  )
  default = {}
}
