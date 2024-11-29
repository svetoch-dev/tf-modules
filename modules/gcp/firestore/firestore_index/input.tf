variable "collection" {
  description = "The collection being indexed"
  type        = string
}

variable "api_scope" {
  description = "api scope, must be ANY_API or DATASTORE_MODE_API"
  type        = string
  default     = "DATASTORE_MODE_API"
}

variable "query_scope" {
  description = "query scope, must be COLLECTION, COLLECTION_GROUP or COLLECTION_RECURSIVE"
  type        = string
  default     = "COLLECTION_GROUP"
}

variable "database" {
  description = "database name"
  type        = string
  default     = "(default)" 
}

variable "fields" {
  description = "An ordered list of properties to index on"
  type = list(
    object(
      {
        field_path = string
        order      = string
      }
    )
  )
}

variable "timeouts" {
  description = "timeouts for index job"
  type = object({
    create = optional(string, "90m")
    delete = optional(string, "90m")
  })
  default = {
    create = "90m"
    delete = "90m"
  }
}