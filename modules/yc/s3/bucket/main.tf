resource "yandex_storage_bucket" "this" {
  access_key              = var.access_key
  secret_key              = var.secret_key
  bucket                  = var.name
  bucket_prefix           = var.name_prefix
  default_storage_class   = var.default_storage_class
  disabled_statickey_auth = var.disabled_statickey_auth
  folder_id               = var.folder_id
  force_destroy           = var.force_destroy
  max_size                = var.max_size
  tags                    = var.tags

  dynamic "anonymous_access_flags" {
    for_each = var.anonymous_access_flags == null ? [] : [var.anonymous_access_flags]
    content {
      config_read = anonymous_access_flags.value.config_read
      list        = anonymous_access_flags.value.list
      read        = anonymous_access_flags.value.read
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }

  dynamic "https" {
    for_each = var.https == null ? [] : [var.https]
    content {
      certificate_id = https.value.certificate_id
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days
      enabled                                = lifecycle_rule.value.enabled
      id                                     = lifecycle_rule.value.id
      prefix                                 = lifecycle_rule.value.prefix

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration == null ? [] : [lifecycle_rule.value.expiration]
        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "filter" {
        for_each = lifecycle_rule.value.filter == null ? [] : [lifecycle_rule.value.filter]
        content {
          object_size_greater_than = filter.value.object_size_greater_than
          object_size_less_than    = filter.value.object_size_less_than
          prefix                   = filter.value.prefix

          dynamic "and" {
            for_each = filter.value.and == null ? [] : [filter.value.and]
            content {
              object_size_greater_than = and.value.object_size_greater_than
              object_size_less_than    = and.value.object_size_less_than
              prefix                   = and.value.prefix
              tags                     = and.value.tags
            }
          }

          dynamic "tag" {
            for_each = filter.value.tag == null ? [] : [filter.value.tag]
            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expiration == null ? [] : [lifecycle_rule.value.noncurrent_version_expiration]
        content {
          days = noncurrent_version_expiration.value.days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.noncurrent_version_transition == null ? [] : [lifecycle_rule.value.noncurrent_version_transition]
        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition == null ? [] : [lifecycle_rule.value.transition]
        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : [var.logging]
    content {
      target_bucket = logging.value.target_bucket
      target_prefix = logging.value.target_prefix
    }
  }

  dynamic "object_lock_configuration" {
    for_each = var.object_lock_configuration == null ? [] : [var.object_lock_configuration]
    content {
      object_lock_enabled = object_lock_configuration.value.object_lock_enabled

      dynamic "rule" {
        for_each = object_lock_configuration.value.rule == null ? [] : [object_lock_configuration.value.rule]
        content {
          default_retention {
            days  = rule.value.default_retention.days
            mode  = rule.value.default_retention.mode
            years = rule.value.default_retention.years
          }
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration == null ? [] : [var.server_side_encryption_configuration]
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = server_side_encryption_configuration.value.rule.apply_server_side_encryption_by_default.kms_master_key_id
          sse_algorithm     = server_side_encryption_configuration.value.rule.apply_server_side_encryption_by_default.sse_algorithm
        }
      }
    }
  }

  versioning {
    enabled = var.versioning
  }

  dynamic "website" {
    for_each = var.website == null ? [] : [var.website]
    content {
      error_document           = website.value.error_document
      index_document           = website.value.index_document
      redirect_all_requests_to = website.value.redirect_all_requests_to
      routing_rules            = website.value.routing_rules
    }
  }
}

resource "yandex_storage_bucket_grant" "this" {
  count = length(var.grant) == 0 ? 0 : 1

  access_key = var.access_key
  secret_key = var.secret_key
  bucket     = yandex_storage_bucket.this.bucket

  dynamic "grant" {
    for_each = var.grant
    content {
      id          = grant.value.id
      permissions = grant.value.permissions
      type        = grant.value.type
      uri         = grant.value.uri
    }
  }
}

resource "yandex_storage_bucket_policy" "this" {
  count = var.policy == null ? 0 : 1

  access_key = var.access_key
  secret_key = var.secret_key
  bucket     = yandex_storage_bucket.this.bucket
  policy     = var.policy
}

resource "yandex_storage_bucket_iam_binding" "this" {
  for_each = {
    for iam_role_obj in var.iam_roles :
    iam_role_obj.role => iam_role_obj
    if length(iam_role_obj.members) != 0
  }
  bucket = yandex_storage_bucket.this.bucket
  role   = each.value.role
  members = [
    for member in each.value.members :
    member
  ]
}
