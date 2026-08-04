variable "settings" {
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
}
