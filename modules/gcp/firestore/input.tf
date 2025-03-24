variable "db" {
  description = "firestore db"
  type = object(
    {
      name             = string
      type             = string
      location_id      = string
      concurrency_mode = optional(string)
      app_engine = optional(
        object(
          {
            integration_mode = optional(string, "DISABLED")
            create           = optional(bool, false)
          },
        )
      )
      delete_protection_state = optional(string, "DELETE_PROTECTION_DISABLED")
      deletion_policy         = optional(string, "ABANDON")
      backup = optional(
        object(
          {
            pitr             = optional(bool, false)
            daily_bp         = optional(bool, false)
            weekly_bp        = optional(bool, false)
            daily_retention  = optional(string, "10080s")
            weekly_retention = optional(string, "10080s")
            recurrence_day   = optional(string, "SUNDAY")
          }
        )
      )
    }
  )
}

variable "firestore_indecies" {
  description = "firestore indices definition"
  type = map(
    object(
      {
        collection  = string
        api_scope   = optional(string, "DATASTORE_MODE_API")
        query_scope = optional(string, "COLLECTION_GROUP")
        database    = optional(string, "(default)")
        fields = list(
          object(
            {
              field_path = string
              order      = string
            }
          )
        )
        timeouts = optional(
          object({
            create = optional(string, "90m")
            delete = optional(string, "90m")
          }),
          {
            create = "90m",
            delete = "90m"
          }
        )
      }
    )
  )
  default = {}
}
