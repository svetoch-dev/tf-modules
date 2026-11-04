variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "display_name" {
  description = "Human-readable display name of the reCAPTCHA Enterprise key"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the key. Only labels present in this map are managed by this module"
  type        = map(string)
  default     = {}
}

variable "android_settings" {
  description = "Settings for keys used by Android apps"
  type = object(
    {
      allow_all_package_names = optional(bool)
      allowed_package_names   = optional(list(string))
    }
  )
  default = null
}

variable "ios_settings" {
  description = "Settings for keys used by iOS apps"
  type = object(
    {
      allow_all_bundle_ids = optional(bool)
      allowed_bundle_ids   = optional(list(string))
    }
  )
  default = null
}

variable "web_settings" {
  description = "Settings for keys used by websites"
  type = object(
    {
      integration_type              = string
      allow_all_domains             = optional(bool)
      allow_amp_traffic             = optional(bool)
      allowed_domains               = optional(list(string))
      challenge_security_preference = optional(string)
    }
  )
  default = null
}

variable "testing_options" {
  description = "Options for user acceptance testing, including a fixed assessment score and challenge behavior"
  type = object(
    {
      testing_challenge = optional(string)
      testing_score     = optional(number)
    }
  )
  default = null
}

variable "waf_settings" {
  description = "Settings for keys used by a Web Application Firewall (WAF)"
  type = object(
    {
      waf_feature = string
      waf_service = string
    }
  )
  default = null
}

variable "timeouts" {
  description = "Timeouts for creating, updating, and deleting the key"
  type = object(
    {
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }
  )
  default = null
}
