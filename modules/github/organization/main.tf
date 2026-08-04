resource "github_organization_settings" "this" {
  billing_email                            = var.settings.billing_email
  name                                     = var.settings.name
  description                              = var.settings.description
  company                                  = var.settings.company
  blog                                     = var.settings.blog
  email                                    = var.settings.email
  location                                 = var.settings.location
  default_repository_permission            = var.settings.default_repository_permission
  has_organization_projects                = var.settings.has_organization_projects
  has_repository_projects                  = var.settings.has_repository_projects
  members_can_create_repositories          = var.settings.members_can_create_repositories
  members_can_create_public_repositories   = var.settings.members_can_create_public_repositories
  members_can_create_private_repositories  = var.settings.members_can_create_private_repositories
  members_can_create_internal_repositories = var.settings.members_can_create_internal_repositories
  members_can_fork_private_repositories    = var.settings.members_can_fork_private_repositories
  web_commit_signoff_required              = var.settings.web_commit_signoff_required
}
