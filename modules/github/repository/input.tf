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
        conditions = object(
          {
            include = list(string)
            exclude = list(string)
          }
        )
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
            creation                      = optional(bool)
            update                        = optional(bool)
            update_allows_fetch_and_merge = optional(bool)
            deletion                      = optional(bool)
            non_fast_forward              = optional(bool)
            required_linear_history       = optional(bool)
            required_signatures           = optional(bool)
            pull_request = optional(
              object(
                {
                  allowed_merge_methods             = optional(list(string))
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
                  strict                   = bool
                  do_not_enforce_on_create = bool
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
  description = "Repository webhooks. Secrets are sensitive but are stored in Terraform state."
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

  validation {
    condition = alltrue([
      for webhook in values(var.webhooks) : contains(["form", "json"], webhook.content_type)
    ])
    error_message = "Webhook content_type must be either \"form\" or \"json\"."
  }

  validation {
    condition = alltrue([
      for webhook in values(var.webhooks) : length(webhook.events) > 0
    ])
    error_message = "Each webhook must contain at least one event."
  }
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
