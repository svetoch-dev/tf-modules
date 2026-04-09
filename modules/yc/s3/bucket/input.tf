variable "access_key" {
  description = "The access key used to apply bucket changes.By default, for authentication, you need to use IAM token with the necessary permissions."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key" {
  description = "The secret key used to apply bucket changes. By default, for authentication, you need to use IAM token with the necessary permissions."
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

variable "grant" {
  description = "ACL grants to apply to the bucket."
  type = list(
    object(
      {
        id          = optional(string)
        permissions = set(string)
        type        = string
        uri         = optional(string)
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

variable "iam_roles" {
  description = "Iam roles for the bucket"
  type = list(
    object(
      {
        role    = string
        members = optional(list(string))
      }
    )
  )
  default = []
}
