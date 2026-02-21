output "network" {
  value = lookup(
    {
      gcp = {
        for network_name, vpc_obj in module.gcp["this"].vpcs :
        network_name => {
          vpcs            = module.gcp.vpcs[network_name]
          subnets         = module.gcp.subnets[network_name]
          nats            = module.gcp.nats[network_name]
          service_peering = module.gcp.service_peering[network_name]
        }
      }
    },
    var.env.cloud.name,
    null
  )
}

output "k8s_clusters" {
  value = lookup(
    {
      gcp = module.gcp.gke
    },
    var.env.cloud.name,
    null
  )
}

output "iam" {
  value = lookup(
    {
      gcp = module.gcp.iam
    },
    var.env.cloud.name,
    null
  )
  sensitive = true
}
