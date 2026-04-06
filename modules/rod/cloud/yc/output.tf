output "network" {
  value = {
    for network_name, vpc_obj in module.yc.vpcs :
    network_name => {
      vpc     = module.yc.vpcs[network_name]
      subnets = module.yc.subnets[network_name]
      nats    = module.yc.nats[network_name]
    }
  }
}

output "iam" {
  value = module.yc.iam
}

output "k8s_clusters" {
  value = {
    for cluster_name, cluster_obj in module.yc.k8s_clusters :
    cluster_name => merge(
      cluster_obj,
      {
        ca_certificate = base64encode(cluster_obj.master[0].cluster_ca_certificate)
        endpoint       = cluster_obj.master[0].external_v4_address
      }
    )
  }
}
