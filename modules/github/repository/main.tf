resource "github_repository" "this" {
  count = var.repository.create ? 1 : 0

  name                        = var.name
  description                 = var.repository.description
  homepage_url                = var.repository.homepage_url
  visibility                  = var.repository.visibility
  archived                    = var.repository.archived
  archive_on_destroy          = var.repository.archive_on_destroy
  auto_init                   = var.repository.auto_init
  gitignore_template          = var.repository.gitignore_template
  license_template            = var.repository.license_template
  is_template                 = var.repository.is_template
  topics                      = var.repository.topics
  has_issues                  = var.repository.has_issues
  has_projects                = var.repository.has_projects
  has_wiki                    = var.repository.has_wiki
  has_discussions             = var.repository.has_discussions
  allow_auto_merge            = var.repository.allow_auto_merge
  allow_merge_commit          = var.repository.allow_merge_commit
  allow_rebase_merge          = var.repository.allow_rebase_merge
  allow_squash_merge          = var.repository.allow_squash_merge
  merge_commit_title          = var.repository.allow_merge_commit ? var.repository.merge_commit_title : null
  merge_commit_message        = var.repository.allow_merge_commit ? var.repository.merge_commit_message : null
  squash_merge_commit_title   = var.repository.allow_squash_merge ? var.repository.squash_merge_commit_title : null
  squash_merge_commit_message = var.repository.allow_squash_merge ? var.repository.squash_merge_commit_message : null
  allow_update_branch         = var.repository.allow_update_branch
  delete_branch_on_merge      = var.repository.delete_branch_on_merge
  web_commit_signoff_required = var.repository.web_commit_signoff_required
}

locals {
  repository_name = var.repository.create ? github_repository.this[0].name : var.name
}

resource "github_repository_ruleset" "this" {
  for_each = var.rulesets

  repository  = local.repository_name
  name        = each.value.name
  target      = each.value.target
  enforcement = each.value.enforcement

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  conditions {
    ref_name {
      include = each.value.include
      exclude = each.value.exclude
    }
  }

  rules {
    creation                = each.value.rules.creation
    update                  = each.value.rules.update
    deletion                = each.value.rules.deletion
    non_fast_forward        = each.value.rules.non_fast_forward
    required_linear_history = each.value.rules.required_linear_history
    required_signatures     = each.value.rules.required_signatures

    dynamic "pull_request" {
      for_each = each.value.rules.pull_request == null ? [] : [each.value.rules.pull_request]
      content {
        dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews_on_push
        require_code_owner_review         = pull_request.value.require_code_owner_review
        require_last_push_approval        = pull_request.value.require_last_push_approval
        required_approving_review_count   = pull_request.value.required_approving_review_count
        required_review_thread_resolution = pull_request.value.required_review_thread_resolution
      }
    }

    dynamic "required_status_checks" {
      for_each = each.value.rules.required_status_checks == null ? [] : [each.value.rules.required_status_checks]
      content {
        strict_required_status_checks_policy = required_status_checks.value.strict

        dynamic "required_check" {
          for_each = required_status_checks.value.checks
          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }
  }
}

resource "github_repository_webhook" "this" {
  for_each = var.webhooks

  repository = local.repository_name
  active     = each.value.active
  events     = each.value.events

  configuration {
    url          = each.value.url
    content_type = each.value.content_type
    insecure_ssl = each.value.insecure_ssl
    secret       = each.value.secret
  }
}

resource "github_repository_deploy_key" "keys" {
  for_each   = var.deploy_keys
  title      = each.value.name
  repository = local.repository_name
  key        = each.value.key
  read_only  = each.value.read_only
}

resource "github_actions_secret" "secrets" {
  for_each = {
    for secret_name, secret_obj in var.secrets :
    secret_name => secret_obj
    if secret_obj != null
  }
  repository  = local.repository_name
  secret_name = each.value.name
  value       = each.value.text_value
}

resource "github_actions_variable" "variable" {
  for_each = {
    for var_name, var_obj in var.vars :
    var_name => var_obj
    if var_obj != null
  }
  repository    = local.repository_name
  variable_name = each.value.name
  value         = each.value.value
}
