variable "repo" {
  description = "git repository related info"
  type = object(
    {
      name  = string
      type  = string
      group = string
    }
  )
}

