resource "google_cloud_scheduler_job" "this" {
  name             = var.name
  description      = var.description
  time_zone        = var.timezone
  schedule         = var.schedule
  region           = var.location == null ? data.google_client_config.this.region : var.location
  paused           = var.paused
  attempt_deadline = var.attempt_deadline

  dynamic "http_target" {
    for_each = var.http_target == null ? {} : { "http_target" = var.http_target }
    content {
      uri         = http_target.value.uri
      http_method = http_target.value.http_method
      body        = http_target.value.body
      headers     = http_target.value.headers

      dynamic "oauth_token" {
        for_each = http_target.value.oauth_token == null ? {} : { "oauth_token" = http_target.value.oauth_token }
        content {
          service_account_email = oauth_token.value.service_account_email
          scope                 = oauth_token.value.scope
        }
      }

      dynamic "oidc_token" {
        for_each = http_target.value.oidc_token == null ? {} : { "oidc_token" = http_target.value.oidc_token }
        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = oidc_token.value.audience
        }
      }
    }
  }

  dynamic "retry_config" {
    for_each = var.retry_configs == null ? {} : { "retry_configs" = var.retry_configs }
    content {
      retry_count          = retry_config.value.retry_count
      max_retry_duration   = retry_config.value.max_retry_duration
      max_backoff_duration = retry_config.value.max_backoff_duration
      min_backoff_duration = retry_config.value.min_backoff_duration
      max_doublings        = retry_config.value.max_doublings
    }
  }

}

data "google_client_config" "this" {}
