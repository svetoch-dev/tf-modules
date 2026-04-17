output "network" {
  value = lookup(
    {
      gcp = {
        for network_name, vpc_obj in module.gcp.vpcs :
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
  value = {
    for k8s_name, k8s_obj in module.gcp.k8s :
    k8s_name => merge(
      k8s_obj,
      {
        ca_certificate = k8s_obj.cluster.master_auth.0.cluster_ca_certificate
        endpoint       = k8s_obj.cluster.endpoint
      }
    )
  }
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
