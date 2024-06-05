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
