module "yc" {
  source = "../../../yc"
  project = {
    id        = var.env.cloud.id
    folder_id = var.env.cloud.folder_id
    zone      = var.env.cloud.location.default_zone
    region    = var.env.cloud.location.region
  }
  networks = local.yc_networks_merged
  iam = provider::deepmerge::mergo(
    #This logic checks if "k8s_federation_id" str is set in
    #local.yc_iam_merged.service_accounts[<sa_name>].federated_credentias[<name>].federation_id
    #if it is than it gets federation id from k8s cluster
    local.yc_iam_merged,
    {
      service_accounts = {
        for sa_name, sa_obj in local.yc_iam_merged.service_accounts :
        sa_name => {
          federated_credentials = {
            for fed_cred_name, fed_cred_obj in try(sa_obj.federated_credentials, {}) :
            fed_cred_name => {
              federation_id = lookup(
                {
                  #If fed_cred_obj.federation_id string is equal to
                  #k8s_federation_id use id of k8s cluster as value 
                  k8s_federation_id = module.yc.k8s_clusters[var.env.short_name].federation.id
                },
                fed_cred_obj.federation_id,
                fed_cred_obj.federation_id #Use value of federation_id by default
              )
            }
          }
        }
      }
    }
  )
  k8s = provider::deepmerge::mergo(
    #This logic checks if subnet names from local.yc_network_merged are set in
    #local.local.yc_k8s_clusters_merged.<cluster>.node_groups.<node_group>.instance_template.network_interface[<index>].subnet_ids
    #if they are it gets the subnet_ids from module outputs
    local.yc_k8s_clusters_merged,
    {
      for k8s_cluster_name, k8s_cluster_obj in local.yc_k8s_clusters_merged :
      k8s_cluster_name => {
        node_groups = {
          for node_group_name, node_group_obj in k8s_cluster_obj.node_groups :
          node_group_name => {
            instance_template = {
              network_interface = [
                for network_interface in try(node_group_obj.instance_template.network_interface, {}) :
                merge(
                  network_interface,
                  {
                    subnet_ids = [
                      for subnet_id in network_interface.subnet_ids :
                      lookup(
                        {
                          for subnet_name, subnet_obj in local.yc_networks_merged["main"].subnets :
                          subnet_name => module.yc.subnets["main"][subnet_name].id
                        },
                        subnet_id,
                        subnet_id # Default value is subnet_id str itself
                      )
                    ]
                  }
                )
              ]
            }
          }
        }
      }
    }
  )
  dns  = local.yc_dns_zones_merged
  ycrs = local.yc_registries_merged
  s3   = local.yc_buckets_merged
}
