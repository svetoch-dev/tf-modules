/* network */

module "network" {
  for_each = {
    for network_name, network_obj in var.networks :
    network_name => network_obj
    if network_obj != null
  }
  source = "./network"

  vpc = merge(
    each.value.vpc,
    {
      folder_id = var.project.folder_id
    }
  )
  subnets        = each.value.subnets
  ip_addresses   = try(each.value.ip_addresses, {})
  nat_gws        = each.value.nat_gws
  firewall_rules = each.value.firewall_rules
}

/* IAM */

module "iam" {
  source           = "./iam"
  service_accounts = var.iam.service_accounts
  roles            = var.iam.roles
  folder_id        = var.project.folder_id
}

/* Kubernetes */

module "k8s" {
  for_each = {
    for k8s_name, k8s_obj in var.k8s :
    k8s_name => k8s_obj
    if k8s_obj != null
  }
  source = "./k8s"

  name                         = try(each.value.name, each.key)
  network_id                   = each.value.network_id
  service_account_id           = try(each.value.service_account_id, null)
  node_service_account_id      = try(each.value.node_service_account_id, null)
  description                  = try(each.value.description, null)
  folder_id                    = try(each.value.folder_id, var.project.folder_id)
  labels                       = try(each.value.labels, {})
  release_channel              = try(each.value.release_channel, "REGULAR")
  network_policy_provider      = try(each.value.network_policy_provider, "CALICO")
  pod_ipv4_range               = try(each.value.pod_ipv4_range, null)
  pod_ipv6_range               = try(each.value.pod_ipv6_range, null)
  service_ipv4_range           = try(each.value.service_ipv4_range, null)
  service_ipv6_range           = try(each.value.service_ipv6_range, null)
  node_ipv4_cidr_mask_size     = try(each.value.node_ipv4_cidr_mask_size, null)
  kms_provider                 = try(each.value.kms_provider, null)
  workload_identity_federation = try(each.value.workload_identity_federation, null)
  admins                       = try(each.value.admins, [])
  viewers                      = try(each.value.viewers, [])
  editors                      = try(each.value.editors, [])
  default_security_groups      = try(each.value.default_security_groups, true)
  network_implementation       = try(each.value.network_implementation, null)
  master                       = each.value.master
  node_groups                  = try(each.value.node_groups, {})
  depends_on = [
    module.iam,
    module.network
  ]
}
