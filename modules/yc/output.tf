output "vpcs" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.vpc
  }
}

output "subnets" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.subnets
  }
}

output "nats" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.nat_gws
  }
}

output "iam" {
  value = module.iam
}

output "k8s_clusters" {
  value = {
    for k8s_name, k8s_obj in module.k8s :
    k8s_name => k8s_obj.cluster
  }
}

output "k8s_node_groups" {
  value = {
    for k8s_name, k8s_obj in module.k8s :
    k8s_name => k8s_obj.node_groups
  }
}

output "s3_buckets" {
  value = {
    for s3_name, s3_obj in module.s3 :
    s3_name => s3_obj.bucket
  }
}

output "s3_objects" {
  value = {
    for s3_name, s3_obj in module.s3 :
    s3_name => s3_obj.objects
  }
}

output "dns_zones" {
  value = {
    for dns_name, dns_obj in module.dns :
    dns_name => dns_obj.zone
  }
}

output "dns_records" {
  value = {
    for dns_name, dns_obj in module.dns :
    dns_name => dns_obj.records
  }
}

output "ycrs" {
  value = {
    for ycr_name, ycr_obj in module.ycrs :
    ycr_name => ycr_obj
  }
}
