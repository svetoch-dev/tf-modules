variable "name" {
  description = "The name of the VPC peering."
  type        = string
}

variable "network" {
  description = "The self_link of the primary network (where the module is deployed)."
  type        = string
}

variable "peer_network" {
  description = "The self_link of the network to peer with."
  type        = string
}

variable "create_reverse_peering" {
  description = "Whether to create the reverse peering from the peer network back to the primary network."
  type        = bool
  default     = true
}
