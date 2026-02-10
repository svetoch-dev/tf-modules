output "network" {
  value = merge(
    var.env.cloud.name == "gcp" ? {
      for network_name, vpc_obj in module.gcp["this"].vpcs :
      network_name => {
        vpcs            = module.gcp["this"].vpcs[network_name]
        subnets         = module.gcp["this"].subnets[network_name]
        nats            = module.gcp["this"].nats[network_name]
        service_peering = module.gcp["this"].service_peering[network_name]
      }
    } : {},
  )
}
