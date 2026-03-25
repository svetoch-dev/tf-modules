variable "vpc" {
  description = "VPC description."
  type = object(
    {
      name        = string
      folder_id   = string
      description = optional(string, null)
      labels      = optional(map(string), {})
      timeouts = optional(
        object(
          {
            create = optional(string)
            update = optional(string)
            delete = optional(string)
          }
        )
      )
    }
  )
}

variable "subnets" {
  description = "Subnets that should be created."
  type = map(
    object(
      {
        ip_cidr_range = string
        zone          = string
        name          = optional(string)
        description   = optional(string, null)
        labels        = optional(map(string), {})
        dhcp_options = optional(
          object(
            {
              domain_name         = optional(string)
              domain_name_servers = optional(list(string))
              ntp_servers         = optional(list(string))
            }
          )
        )
        timeouts = optional(
          object(
            {
              create = optional(string)
              update = optional(string)
              delete = optional(string)
            }
          )
        )
        static_routes = optional(
          list(
            object(
              {
                destination_prefix = string
                next_hop_address   = string
              }
            )
          ),
          []
        )
      }
    )
  )
}

variable "nat_gws" {
  description = "Map of NAT gateways to create."
  type = map(
    object(
      {
        name        = optional(string)
        description = optional(string, null)
        labels      = optional(map(string), {})
        timeouts = optional(
          object(
            {
              create = optional(string)
              update = optional(string)
              delete = optional(string)
            }

          )
        )
        subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS")
        subnetworks                 = optional(list(string), [])
      }
    )
  )
  default = {}
}

variable "ip_addresses" {
  description = "List of public IP addresses to reserve."
  type = map(
    object(
      {
        name                = optional(string)
        description         = optional(string, null)
        labels              = optional(map(string), {})
        deletion_protection = optional(bool, false)
        dns_record = optional(
          list(
            object(
              {
                dns_zone_id = string
                fqdn        = string
                ptr         = optional(bool)
                ttl         = optional(number)
              }
            )
          ),
          []
        )
        external_ipv4_address = object(
          {
            zone_id                  = optional(string)
            ddos_protection_provider = optional(string)
            outgoing_smtp_capability = optional(string)
          }
        )
        timeouts = optional(
          object(
            {
              create = optional(string)
              update = optional(string)
              delete = optional(string)
            }
          )
        )
      }
    )
  )
  default = {}
}

variable "firewall_rules" {
  description = "Firewall rules."
  type = map(
    object(
      {
        direction     = string
        name          = optional(string)
        source_ranges = optional(list(string), [])
        description   = optional(string, null)
        allow = optional(
          map(
            object(
              {
                ports = optional(list(string), [])
              }
            )
          ),
          {}
        )
      }
    )
  )
  default = {}
}
