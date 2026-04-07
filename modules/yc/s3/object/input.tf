variable "access_key" {
  description = "The access key used to apply object changes."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key" {
  description = "The secret key used to apply object changes."
  type        = string
  default     = null
  sensitive   = true
}

variable "bucket" {
  description = "The name of the containing bucket."
  type        = string
}

variable "name" {
  description = "The name of the object once it is in the bucket."
  type        = string
}

variable "acl" {
  description = "The predefined ACL to apply."
  type        = string
  default     = null
}

variable "content" {
  description = "Literal UTF-8 content to upload. Conflicts with source and content_base64."
  type        = string
  default     = null

  validation {
    condition = (
      (var.content == null ? 0 : 1) +
      (var.content_base64 == null ? 0 : 1) +
      (var.object_source == null ? 0 : 1)
    ) <= 1
    error_message = "Only one of content, content_base64, or source can be set."
  }
}

variable "content_base64" {
  description = "Base64-encoded content to upload. Conflicts with content and source."
  type        = string
  default     = null
}

variable "content_type" {
  description = "MIME type describing the object data."
  type        = string
  default     = null
}

variable "object_lock_legal_hold_status" {
  description = "Legal hold status for the object."
  type        = string
  default     = null
}

variable "object_lock_mode" {
  description = "Object lock mode. Must be set together with object_lock_retain_until_date."
  type        = string
  default     = null

  validation {
    condition     = (var.object_lock_mode == null) == (var.object_lock_retain_until_date == null)
    error_message = "object_lock_mode and object_lock_retain_until_date must be set together."
  }
}

variable "object_lock_retain_until_date" {
  description = "RFC3339 timestamp until which the object is locked. Must be set together with object_lock_mode."
  type        = string
  default     = null
}

variable "object_source" {
  description = "Path to a file to upload. Conflicts with content and content_base64."
  type        = string
  default     = null
}

variable "object_source_hash" {
  description = "Hash of the source content used to trigger updates when object_source changes."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags assigned to the object."
  type        = map(string)
  default     = null
}
