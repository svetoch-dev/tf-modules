variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = null
}


variable "bucket_policy_only" {
  description = "Enables Bucket Policy Only access to a bucket."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = true
}

variable "autoclass" {
  description = "While set to true, autoclass is enabled for this bucket."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object(
    {
      is_locked        = bool
      retention_period = number
    }
  )
  default = null
}

variable "custom_placement_config" {
  description = "Configuration of the bucket's custom location in a dual-region bucket setup. If the bucket is designated a single or multi-region, the variable are null."
  type = object(
    {
      data_locations = list(string)
    }
  )
  default = null
}

variable "cors" {
  description = "Configuration of CORS for bucket with structure as defined in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#cors."
  type = list(
    object(
      {
        origins = optional(
          list(string)
        )
        methods = optional(
          list(string)
        )
        response_headers = optional(
          list(string)
        )
        max_age_seconds = optional(number)
      }
    )
  )
  default = []
}

variable "encryption" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object(
    {
      default_kms_key_name = string
    }
  )
  default = null
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(
    object(
      {
        action = object(
          {
            type          = string
            storage_class = optional(string)
          }
        )
        condition = object(
          {
            age            = optional(number)
            no_age         = optional(bool, false)
            created_before = optional(string)
            with_state     = optional(string)
            matches_storage_class = optional(
              list(string),
            )
            matches_prefix = optional(
              list(string),
            )
            matches_suffix = optional(
              list(string),
            )
            num_newer_versions         = optional(string)
            custom_time_before         = optional(string)
            days_since_custom_time     = optional(number)
            days_since_noncurrent_time = optional(number)
            noncurrent_time_before     = optional(string)
          }
        )
      }
    )
  )
  default = []
}

variable "logging" {
  description = "Bucket logging configuration."
  type = object(
    {
      bucket        = string
      object_prefix = string
    }
  )
  default = null
}

variable "website" {
  type = object(
    {
      main_page_suffix = optional(string)
      not_found_page   = optional(string)
    }
  )
  description = "Website values"
  default     = null
}

variable "public_access_prevention" {
  description = "Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention, only if the bucket is subject to the public access prevention organization policy constraint."
  type        = string
  default     = "inherited"
}

variable "iam_roles" {
  description = "Iam roles for the bucket"
  type = list(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
}
