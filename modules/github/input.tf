variable "repositories" {
  description = "GitHub repositories. Webhook secrets are sensitive but are stored in Terraform state."
  type = map(
    object(
      {
        name = string
        org  = string
        repository = optional(
          object(
            {
              create                      = optional(bool, false)
              description                 = optional(string)
              homepage_url                = optional(string)
              visibility                  = optional(string, "private")
              archived                    = optional(bool, false)
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
              allow_auto_merge            = optional(bool, false)
              allow_merge_commit          = optional(bool, true)
              allow_rebase_merge          = optional(bool, true)
              allow_squash_merge          = optional(bool, true)
              merge_commit_title          = optional(string)
              merge_commit_message        = optional(string)
              squash_merge_commit_title   = optional(string)
              squash_merge_commit_message = optional(string)
              allow_update_branch         = optional(bool)
              delete_branch_on_merge      = optional(bool, false)
              web_commit_signoff_required = optional(bool)
            }
          ), {}
        )
        rulesets = optional(
          map(
            object(
              {
                name        = string
                target      = optional(string, "branch")
                enforcement = optional(string, "active")
                conditions = optional(
                  object(
                    {
                      include = optional(list(string), ["~DEFAULT_BRANCH"])
                      exclude = optional(list(string), [])
                    }
                  ), {}
                )
                bypass_actors = optional(
                  list(
                    object(
                      {
                        actor_id    = optional(number)
                        actor_type  = string
                        bypass_mode = optional(string, "always")
                      }
                    )
                  ), []
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
                          dismiss_stale_reviews_on_push     = optional(bool, false)
                          require_code_owner_review         = optional(bool, false)
                          require_last_push_approval        = optional(bool, false)
                          required_approving_review_count   = optional(number, 0)
                          required_review_thread_resolution = optional(bool, false)
                        }
                      )
                    )
                    required_status_checks = optional(
                      object(
                        {
                          strict                   = optional(bool, false)
                          do_not_enforce_on_create = optional(bool, false)
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
          ), {}
        )
        webhooks = optional(
          map(
            object(
              {
                url          = string
                events       = set(string)
                active       = optional(bool, true)
                content_type = optional(string, "json")
                insecure_ssl = optional(bool, false)
                secret       = optional(string)
              }
            )
          ), {}
        )
        deploy_keys = optional(
          map(
            object(
              {
                name        = string
                public_key  = optional(string, "")
                private_key = optional(string, "")
                read_only   = bool
                create      = optional(bool, false)
              }
            )
          ), {}
        )
        secrets = optional(
          map(
            object(
              {
                name       = string
                text_value = string
              }
            )
          ), {}
        )
        vars = optional(
          map(
            object(
              {
                name  = string
                value = string
              }
            )
          ), {}
        )
      }
    )
  )

  validation {
    condition = alltrue(flatten([
      for repository in values(var.repositories) : [
        for webhook in values(repository.webhooks) : contains(["form", "json"], webhook.content_type)
      ]
    ]))
    error_message = "Webhook content_type must be either \"form\" or \"json\"."
  }

  validation {
    condition = alltrue(flatten([
      for repository in values(var.repositories) : [
        for webhook in values(repository.webhooks) : length(webhook.events) > 0
      ]
    ]))
    error_message = "Each webhook must contain at least one event."
  }
}
