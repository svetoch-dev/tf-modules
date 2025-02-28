variable "api_tokens" {
  description = "Map of cloudflare api_tokens"
  type        = any
  default     = {}
}

variable "pages" {
  description = "Map of cloudflare pages configuration"
  type        = any
  default     = {}
}

variable "dns_zones" {
  description = "Map of cloudflare dns zones configuration"
  type        = any
  default     = {}
}
