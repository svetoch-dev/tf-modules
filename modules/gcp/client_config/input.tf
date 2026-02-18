variable "provider_config" {
  description = "provider configuration"
  type = object(
    {
      id           = string
      region       = string
      default_zone = string
    }
  )
}
