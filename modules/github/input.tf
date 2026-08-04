variable "organization" {
  description = "GitHub organization settings"
  type = object({
    billing_email                            = string
    name                                     = optional(string)
    description                              = optional(string)
    company                                  = optional(string)
    blog                                     = optional(string)
    email                                    = optional(string)
    location                                 = optional(string)
    default_repository_permission            = optional(string)
    has_organization_projects                = optional(bool)
    has_repository_projects                  = optional(bool)
    members_can_create_repositories          = optional(bool)
    members_can_create_public_repositories   = optional(bool)
    members_can_create_private_repositories  = optional(bool)
    members_can_create_internal_repositories = optional(bool)
    members_can_fork_private_repositories    = optional(bool)
    web_commit_signoff_required              = optional(bool)
  })
  default = null
}

variable "repositories" {
  description = "Github repositories"
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
              archive_on_destroy          = optional(bool, true)
              auto_init                   = optional(bool, false)
              gitignore_template          = optional(string)
              license_template            = optional(string)
              is_template                 = optional(bool, false)
              topics                      = optional(set(string), [])
              has_issues                  = optional(bool, true)
              has_projects                = optional(bool, true)
              has_wiki                    = optional(bool, true)
              has_discussions             = optional(bool, false)
              allow_auto_merge            = optional(bool, false)
              allow_merge_commit          = optional(bool, true)
              allow_rebase_merge          = optional(bool, true)
              allow_squash_merge          = optional(bool, true)
              allow_update_branch         = optional(bool, false)
              delete_branch_on_merge      = optional(bool, false)
              web_commit_signoff_required = optional(bool, false)
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
                include     = optional(list(string), ["~DEFAULT_BRANCH"])
                exclude     = optional(list(string), [])
                rules = object(
                  {
                    creation                = optional(bool, false)
                    update                  = optional(bool, false)
                    deletion                = optional(bool, false)
                    non_fast_forward        = optional(bool, false)
                    required_linear_history = optional(bool, false)
                    required_signatures     = optional(bool, false)
                    pull_request = optional(
                      object(
                        {
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
                          strict = optional(bool, false)
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
}
