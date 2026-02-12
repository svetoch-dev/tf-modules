output "network" {
  value = lookup(
    {
      gcp = {
        for network_name, vpc_obj in module.gcp["this"].vpcs :
        network_name => {
          vpcs            = module.gcp["this"].vpcs[network_name]
          subnets         = module.gcp["this"].subnets[network_name]
          nats            = module.gcp["this"].nats[network_name]
          service_peering = module.gcp["this"].service_peering[network_name]
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
      gcp = module.gcp["this"].gke
    },
    var.env.cloud.name,
    null
  )
}

output "iam" {
  value = lookup(
    {
      gcp = module.gcp["this"].iam
    },
    var.env.cloud.name,
    null
  )
  sensitive = true
}
