locals {
  gcp_k8s_clusters = {
    tostring(var.env.short_name) = {
      node_pools = {
        runner = {
          name = "runner"
          node_config = {
            machine_type    = "t2d-standard-4"
            service_account = "k8s-nodes@${var.env.cloud.id}.iam.gserviceaccount.com"
            disk_size_gb    = 120
            spot            = true
            labels = {
              runner = "true"
            }
            taint = [
              {
                key    = "runner"
                value  = "true"
                effect = "NO_SCHEDULE"
              },
            ]
          }
          autoscaling = {
            min_node_count = 0
            max_node_count = 20
          }
          network_config = {
            pod_range = module.internal.network["main"].subnets["vms"].secondary_ip_range[0].range_name
          }
        }
      }
    }
  }
}
