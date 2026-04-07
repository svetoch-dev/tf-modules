variable "access_key" {
  description = "The access key used to apply bucket and object changes."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key" {
  description = "The secret key used to apply bucket and object changes."
  type        = string
  default     = null
  sensitive   = true
}

variable "name" {
  description = "The bucket name"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for generating a unique bucket name."
  type        = string
  default     = null
}

variable "default_storage_class" {
  description = "Default storage class for objects in the bucket."
  type        = string
  default     = "STANDARD"
}

variable "disabled_statickey_auth" {
  description = "Whether static key authentication is disabled for the bucket."
  type        = bool
  default     = null
}

variable "folder_id" {
  description = "Folder ID where the bucket will be created."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to delete all objects before destroying the bucket."
  type        = bool
  default     = false
}

variable "max_size" {
  description = "Maximum bucket size in bytes."
  type        = number
  default     = null
}

variable "policy" {
  description = "Bucket policy JSON document."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags assigned to the bucket."
  type        = map(string)
  default     = null
}

variable "anonymous_access_flags" {
  description = "Anonymous access flags for the bucket."
  type = object(
    {
      config_read = optional(bool)
      list        = optional(bool)
      read        = optional(bool)
    }
  )
  default = null
}


variable "admins" {
  description = "IAM member strings that should receive the storage.admin role. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:' and 'userAccountName:' are also allowed and are resolved by the module."
  type        = list(string)
  default     = []
}

variable "viewers" {
  description = "IAM member strings that should receive the storage.viewer role. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:' and 'userAccountName:' are also allowed and are resolved by the module."
  type        = list(string)
  default     = []
}

variable "editors" {
  description = "IAM member strings that should receive the storage.editor role. Must use Yandex Cloud IAM member format such as 'serviceAccount:<id>', 'userAccount:<login>', 'group:<id>' etc. Special prefixes 'serviceAccountName:' and 'userAccountName:' are also allowed and are resolved by the module."
  type        = list(string)
  default     = []
}

variable "cors_rule" {
  description = "Cross-origin resource sharing rules."
  type = list(
    object(
      {
        allowed_headers = optional(list(string))
        allowed_methods = list(string)
        allowed_origins = list(string)
        expose_headers  = optional(list(string))
        max_age_seconds = optional(number)
      }
    )
  )
  default = []
}

variable "https" {
  description = "HTTPS certificate configuration for the bucket."
  type = object(
    {
      certificate_id = string
    }
  )
  default = null
}

variable "lifecycle_rules" {
  description = "Lifecycle management rules for bucket objects."
  type = list(
    object(
      {
        abort_incomplete_multipart_upload_days = optional(number)
        enabled                                = bool
        id                                     = optional(string)
        prefix                                 = optional(string)
        expiration = optional(
          object(
            {
              date                         = optional(string)
              days                         = optional(number)
              expired_object_delete_marker = optional(bool)
            }
          )
        )
        filter = optional(
          object(
            {
              object_size_greater_than = optional(number)
              object_size_less_than    = optional(number)
              prefix                   = optional(string)
              and = optional(
                object(
                  {
                    object_size_greater_than = optional(number)
                    object_size_less_than    = optional(number)
                    prefix                   = optional(string)
                    tags                     = optional(map(string))
                  }
                )
              )
              tag = optional(
                object(
                  {
                    key   = string
                    value = string
                  }
                )
              )
            }
          )
        )
        noncurrent_version_expiration = optional(
          object(
            {
              days = number
            }
          )
        )
        noncurrent_version_transition = optional(
          object(
            {
              days          = number
              storage_class = string
            }
          )
        )
        transition = optional(
          object(
            {
              date          = optional(string)
              days          = optional(number)
              storage_class = string
            }
          )
        )
      }
    )
  )
  default = []
}

variable "logging" {
  description = "Bucket access logging configuration."
  type = object(
    {
      target_bucket = string
      target_prefix = optional(string)
    }
  )
  default = null
}

variable "object_lock_configuration" {
  description = "Object lock configuration for the bucket."
  type = object(
    {
      object_lock_enabled = string
      rule = optional(
        object(
          {
            default_retention = object(
              {
                days  = optional(number)
                mode  = string
                years = optional(number)
              }
            )
          }
        )
      )
    }
  )
  default = null
}

variable "server_side_encryption_configuration" {
  description = "Server-side encryption configuration for the bucket."
  type = object(
    {
      rule = object(
        {
          apply_server_side_encryption_by_default = object(
            {
              kms_master_key_id = string
              sse_algorithm     = string
            }
          )
        }
      )
    }
  )
  default = null
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = false
}

variable "website" {
  description = "Static website hosting configuration."
  type = object(
    {
      error_document           = optional(string)
      index_document           = optional(string)
      redirect_all_requests_to = optional(string)
      routing_rules            = optional(string)
    }
  )
  default = null
}

variable "objects" {
  description = "Map of objects to create in the bucket."
  type = map(
    object(
      {
        name                          = optional(string, null)
        acl                           = optional(string, null)
        content                       = optional(string, null)
        content_base64                = optional(string, null)
        content_type                  = optional(string, null)
        object_lock_legal_hold_status = optional(string, null)
        object_lock_mode              = optional(string, null)
        object_lock_retain_until_date = optional(string, null)
        object_source                 = optional(string, null)
        object_source_hash            = optional(string, null)
        tags                          = optional(map(string), null)
      }
    )
  )
  default = {}

  validation {
    condition = alltrue([
      for object_name, object_obj in var.objects :
      (
        (object_obj.content == null ? 0 : 1) +
        (object_obj.content_base64 == null ? 0 : 1) +
        (object_obj.object_source == null ? 0 : 1)
      ) <= 1
    ])
    error_message = "Each object can set only one of content, content_base64, or object_source."
  }

  validation {
    condition = alltrue([
      for object_name, object_obj in var.objects :
      (object_obj.object_lock_mode == null) == (object_obj.object_lock_retain_until_date == null)
    ])
    error_message = "Each object must set object_lock_mode and object_lock_retain_until_date together."
  }
}
