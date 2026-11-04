resource "google_recaptcha_enterprise_key" "this" {
  project      = var.project_id
  display_name = var.display_name
  labels       = var.labels

  dynamic "android_settings" {
    for_each = var.android_settings == null ? [] : [var.android_settings]
    content {
      allow_all_package_names = android_settings.value.allow_all_package_names
      allowed_package_names   = android_settings.value.allowed_package_names
    }
  }

  dynamic "ios_settings" {
    for_each = var.ios_settings == null ? [] : [var.ios_settings]
    content {
      allow_all_bundle_ids = ios_settings.value.allow_all_bundle_ids
      allowed_bundle_ids   = ios_settings.value.allowed_bundle_ids
    }
  }

  dynamic "web_settings" {
    for_each = var.web_settings == null ? [] : [var.web_settings]
    content {
      integration_type              = web_settings.value.integration_type
      allow_all_domains             = web_settings.value.allow_all_domains
      allow_amp_traffic             = web_settings.value.allow_amp_traffic
      allowed_domains               = web_settings.value.allowed_domains
      challenge_security_preference = web_settings.value.challenge_security_preference
    }
  }

  dynamic "testing_options" {
    for_each = var.testing_options == null ? [] : [var.testing_options]
    content {
      testing_challenge = testing_options.value.testing_challenge
      testing_score     = testing_options.value.testing_score
    }
  }

  dynamic "waf_settings" {
    for_each = var.waf_settings == null ? [] : [var.waf_settings]
    content {
      waf_feature = waf_settings.value.waf_feature
      waf_service = waf_settings.value.waf_service
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}
