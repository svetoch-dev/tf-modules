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
  default_service_account      = try(each.value.default_service_account, false)
  default_node_service_account = try(each.value.default_node_service_account, false)
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

/* S3 */

module "s3" {
  for_each = {
    for s3_name, s3_obj in var.s3 :
    s3_name => s3_obj
    if s3_obj != null
  }
  source = "./s3"

  access_key                           = try(each.value.access_key, null)
  secret_key                           = try(each.value.secret_key, null)
  name                                 = try(each.value.name, each.key)
  name_prefix                          = try(each.value.name_prefix, null)
  default_storage_class                = try(each.value.default_storage_class, "STANDARD")
  disabled_statickey_auth              = try(each.value.disabled_statickey_auth, null)
  folder_id                            = try(each.value.folder_id, var.project.folder_id)
  force_destroy                        = try(each.value.force_destroy, false)
  max_size                             = try(each.value.max_size, null)
  policy                               = try(each.value.policy, null)
  tags                                 = try(each.value.tags, null)
  anonymous_access_flags               = try(each.value.anonymous_access_flags, null)
  cors_rule                            = try(each.value.cors_rule, [])
  https                                = try(each.value.https, null)
  lifecycle_rules                      = try(each.value.lifecycle_rules, [])
  logging                              = try(each.value.logging, null)
  object_lock_configuration            = try(each.value.object_lock_configuration, null)
  server_side_encryption_configuration = try(each.value.server_side_encryption_configuration, null)
  versioning                           = try(each.value.versioning, false)
  website                              = try(each.value.website, null)
  admins                               = try(each.value.admins, [])
  viewers                              = try(each.value.viewers, [])
  editors                              = try(each.value.editors, [])
  objects                              = try(each.value.objects, {})
  depends_on = [
    module.iam,
  ]
}
