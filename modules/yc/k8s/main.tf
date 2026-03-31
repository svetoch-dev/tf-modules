module "cluster" {
  source = "./cluster"

  name                         = var.name
  description                  = var.description
  folder_id                    = var.folder_id
  labels                       = var.labels
  network_id                   = var.network_id
  service_account_id           = var.service_account_id
  node_service_account_id      = var.node_service_account_id
  master                       = var.master
  release_channel              = var.release_channel
  network_policy_provider      = var.network_policy_provider
  pod_ipv4_range               = var.pod_ipv4_range
  pod_ipv6_range               = var.pod_ipv6_range
  service_ipv4_range           = var.service_ipv4_range
  service_ipv6_range           = var.service_ipv6_range
  node_ipv4_cidr_mask_size     = var.node_ipv4_cidr_mask_size
  kms_provider                 = var.kms_provider
  workload_identity_federation = var.workload_identity_federation
  iam_roles = [
    {
      role    = "k8s.admin"
      members = module.admin_members.converted
    },
    {
      role    = "k8s.editor"
      members = module.editor_members.converted
    },
    {
      role    = "k8s.viewer"
      members = module.viewer_members.converted
    },
  ]
}

module "node_groups" {
  source   = "./node_group"
  for_each = var.node_groups

  cluster_id                   = module.cluster.this.id
  name                         = each.value.name
  description                  = each.value.description
  version                      = each.value.version
  labels                       = each.value.labels
  node_labels                  = each.value.node_labels
  node_taints                  = each.value.node_taints
  allowed_unsafe_sysctls       = each.value.allowed_unsafe_sysctls
  variables                    = each.value.variables
  allocation_policy            = each.value.allocation_policy
  deploy_policy                = each.value.deploy_policy
  instance_template            = each.value.instance_template
  maintenance_policy           = each.value.maintenance_policy
  scale_policy                 = each.value.scale_policy
  workload_identity_federation = each.value.workload_identity_federation
}

module "admin_members" {
  source  = "../iam/members"
  members = var.admins
}

module "viewer_members" {
  source  = "../iam/members"
  members = var.viewers
}

module "editor_members" {
  source  = "../iam/members"
  members = var.editors
}
