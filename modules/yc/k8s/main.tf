locals {
  node_groups = {
    for node_group_name, node_group_obj in var.node_groups :
    node_group_name => {
      name                   = node_group_obj.name
      description            = node_group_obj.description
      k8s_version            = node_group_obj.k8s_version
      labels                 = node_group_obj.labels
      node_labels            = node_group_obj.node_labels
      node_taints            = node_group_obj.node_taints
      allowed_unsafe_sysctls = node_group_obj.allowed_unsafe_sysctls
      variables              = node_group_obj.variables
      allocation_policy      = node_group_obj.allocation_policy
      deploy_policy          = node_group_obj.deploy_policy
      instance_template = {
        labels                    = node_group_obj.instance_template.labels
        metadata                  = node_group_obj.instance_template.metadata
        name                      = node_group_obj.instance_template.name
        nat                       = node_group_obj.instance_template.nat
        network_acceleration_type = node_group_obj.instance_template.network_acceleration_type
        platform_id               = node_group_obj.instance_template.platform_id
        reserved_instance_pool_id = node_group_obj.instance_template.reserved_instance_pool_id
        boot_disk                 = node_group_obj.instance_template.boot_disk
        container_network         = node_group_obj.instance_template.container_network
        container_runtime         = node_group_obj.instance_template.container_runtime
        gpu_settings              = node_group_obj.instance_template.gpu_settings
        network_interface = [
          for interface in node_group_obj.instance_template.network_interface :
          merge(
            interface,
            {
              security_group_ids = concat(
                interface.security_group_ids,
                var.default_security_groups == false ? [] :
                [
                  module.node_sg[0].this.id,
                  module.master_node_sg[0].this.id
                ]
              )
            }
          )

        ]
        placement_policy  = node_group_obj.instance_template.placement_policy
        resources         = node_group_obj.instance_template.resources
        scheduling_policy = node_group_obj.instance_template.scheduling_policy
      }
      maintenance_policy           = node_group_obj.maintenance_policy
      scale_policy                 = node_group_obj.scale_policy
      workload_identity_federation = node_group_obj.workload_identity_federation
    }
    if node_group_obj != null
  }
}

module "cluster" {
  source = "./cluster"

  name                    = var.name
  description             = var.description
  folder_id               = var.folder_id
  labels                  = var.labels
  network_id              = var.network_id
  service_account_id      = var.service_account_id
  node_service_account_id = var.node_service_account_id
  master = merge(
    var.master,
    {
      security_group_ids = concat(
        var.master.security_group_ids,
        var.default_security_groups == false ? [] :
        [
          module.master_sg[0].this.id,
          module.master_node_sg[0].this.id
        ]
      )
    }
  )
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
  for_each = local.node_groups

  cluster_id                   = module.cluster.this.id
  name                         = each.value.name
  description                  = each.value.description
  k8s_version                  = each.value.k8s_version
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

module "master_sg" {
  count      = var.default_security_groups ? 1 : 0
  source     = "../network/security_group"
  name       = "master-sg"
  folder_id  = var.folder_id
  network_id = var.network_id
  ingress = [
    {
      protocol          = "ANY"
      description       = "Rule allows availability checks from load balancer's address range. It is required for load balancer services."
      predefined_target = "loadbalancer_healthchecks"
      from_port         = 0
      to_port           = 65535
    },
  ]
  egress = [
    {
      protocol       = "UDP"
      description    = "Allows masters to connect to NTP servers for time synchronization"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 123
    },
  ]
}

module "master_node_sg" {
  count      = var.default_security_groups ? 1 : 0
  source     = "../network/security_group"
  name       = "master-node-sg"
  folder_id  = var.folder_id
  network_id = var.network_id
  ingress = [
    {
      protocol          = "ANY"
      description       = "Rule allows master-node and node-node communication inside a security group."
      predefined_target = "self_security_group"
      from_port         = 0
      to_port           = 65535
    },
    {
      protocol       = "ANY"
      description    = "Rule allows pod-pod and service-service communication inside a security group."
      v4_cidr_blocks = [var.pod_ipv4_range, var.service_ipv4_range]
      from_port      = 0
      to_port        = 65535
    }
  ]
  egress = [
    {
      protocol          = "ANY"
      description       = "Rule allows master-node and node-node communication inside a security group."
      predefined_target = "self_security_group"
      security_group_id = module.node_sg[0].this.id
      from_port         = 0
      to_port           = 65535
    },
    {
      protocol       = "ANY"
      description    = "Rule allows pod-pod and service-service communication inside a security group."
      v4_cidr_blocks = [var.pod_ipv4_range, var.service_ipv4_range]
      from_port      = 0
      to_port        = 65535
    }
  ]
}

module "node_sg" {
  count      = var.default_security_groups ? 1 : 0
  source     = "../network/security_group"
  name       = "node-sg"
  folder_id  = var.folder_id
  network_id = var.network_id
  ingress = [
    {
      description    = "Rule allows incoming traffic from the Internet to the NodePort port range."
      v4_cidr_blocks = ["0.0.0.0/0"]
      protocol       = "TCP"
      from_port      = 30000
      to_port        = 32767
    },
  ]
  egress = [
    {
      protocol       = "ANY"
      description    = "Rule allows all outgoing traffic."
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65535
    },
  ]
}
