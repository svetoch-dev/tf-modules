variable "provider" {
  description = "provider configuration"
  type = object(
    {
      id           = string
      region       = string
      default_zone = string
      foder_id     = string
    }
  )
}
