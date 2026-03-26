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
