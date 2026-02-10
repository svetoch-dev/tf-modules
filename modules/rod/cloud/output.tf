output "network" {
  value = merge(
    var.env.cloud.name == "gcp" ? {
      vpcs            = module.gcp["this"].vpcs
      subnets         = module.gcp["this"].subnets
      nats            = module.gcp["this"].nats
      service_peering = module.gcp["this"].service_peering
    } : {},
  )
}
