locals {
  #Yandex cloud provider needs subject (service accounts,users)
  #ids for *_iam_member and *_iam_bindings resources. We cant
  #get ids before we create service accounts so we introduce
  #a new serviceAccountName:<sa_name> userAccountName:<user_email>
  #strings when used we will get sa ids from module.iam and
  #user ids from data sources. More info
  #https://github.com/svetoch-dev/tf-modules/pull/77
  members_k8s = distinct(
    flatten(
      [
        for k8s_name, k8s_obj in var.k8s :
        concat(
          lookup(k8s_obj, "viewer_names", []),
          lookup(k8s_obj, "admin_names", []),
          lookup(k8s_obj, "editor_names", []),
        )
        if k8s_obj != null
      ]
    ),
  )
  members_s3 = distinct(
    flatten(
      [
        for s3_name, s3_obj in var.s3 :
        concat(
          lookup(s3_obj, "viewer_names", []),
          lookup(s3_obj, "admin_names", []),
          lookup(s3_obj, "editor_names", []),
        )
        if s3_obj != null
      ]
    )
  )
  members_dns = distinct(
    flatten(
      [
        for dns_name, dns_obj in var.dns :
        concat(
          lookup(dns_obj, "viewer_names", []),
          lookup(dns_obj, "admin_names", []),
          lookup(dns_obj, "editor_names", []),
        )
        if dns_obj != null
      ]
    )
  )
  members_ycrs = distinct(
    flatten(
      [
        for ycr_name, ycr_obj in var.ycrs :
        concat(
          lookup(ycr_obj, "reader_names", []),
          lookup(ycr_obj, "writer_names", []),
        )
        if ycr_obj != null
      ]
    )
  )
}

module "members_k8s" {
  source = "./iam/member"
  for_each = toset(
    [
      for member in local.members_k8s :
      member
    ]
  )
  member = each.value
}

module "members_s3" {
  source = "./iam/member"
  for_each = toset(
    [
      for member in local.members_s3 :
      member
    ]
  )
  member = each.value
}

module "members_dns" {
  source = "./iam/member"
  for_each = toset(
    [
      for member in local.members_dns :
      member
    ]
  )
  member = each.value
}

module "members_ycrs" {
  source = "./iam/member"
  for_each = toset(
    [
      for member in local.members_ycrs :
      member
    ]
  )
  member = each.value
}

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
    if k8s_obj != null && k8s_obj.enabled
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
  default_security_groups      = try(each.value.default_security_groups, true)
  network_implementation       = try(each.value.network_implementation, null)
  admins = concat(
    lookup(each.value, "admins", [])
    ,
    [
      for member in lookup(each.value, "admin_names", []) :
      module.members_k8s[member].converted
    ]
  )
  viewers = concat(
    lookup(each.value, "viewers", [])
    ,
    [
      for member in lookup(each.value, "viewer_names", []) :
      module.members_k8s[member].converted
    ]
  )
  editors = concat(
    lookup(each.value, "editors", [])
    ,
    [
      for member in lookup(each.value, "editor_names", []) :
      module.members_k8s[member].converted
    ]
  )
  node_groups = lookup(each.value, "node_groups", {})
  master      = each.value.master
  depends_on = [
    module.network,
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
  objects                              = try(each.value.objects, {})
  admins = concat(
    lookup(each.value, "admins", [])
    ,
    [
      for member in lookup(each.value, "admin_names", []) :
      module.members_s3[member].converted
    ]
  )
  viewers = concat(
    lookup(each.value, "viewers", [])
    ,
    [
      for member in lookup(each.value, "viewer_names", []) :
      module.members_s3[member].converted
    ]
  )
  editors = concat(
    lookup(each.value, "editors", [])
    ,
    [
      for member in lookup(each.value, "editor_names", []) :
      module.members_s3[member].converted
    ]
  )

  depends_on = [
    module.iam
  ]
}

/* DNS */

module "dns" {
  for_each = {
    for dns_name, dns_obj in var.dns :
    dns_name => dns_obj
    if dns_obj != null
  }
  source = "./dns"

  folder_id           = try(each.value.folder_id, var.project.folder_id)
  name                = try(each.value.name, each.key)
  zone                = each.value.zone
  description         = try(each.value.description, "")
  labels              = try(each.value.labels, {})
  public              = try(each.value.public, true)
  private_networks    = try(each.value.private_networks, [])
  deletion_protection = try(each.value.deletion_protection, false)
  admins = concat(
    lookup(each.value, "admins", [])
    ,
    [
      for member in lookup(each.value, "admin_names", []) :
      module.members_dns[member].converted
    ]
  )
  viewers = concat(
    lookup(each.value, "viewers", [])
    ,
    [
      for member in lookup(each.value, "viewer_names", []) :
      module.members_dns[member].converted
    ]
  )
  editors = concat(
    lookup(each.value, "editors", [])
    ,
    [
      for member in lookup(each.value, "editor_names", []) :
      module.members_dns[member].converted
    ]
  )
  timeouts = try(each.value.timeouts, null)
  records  = try(each.value.records, [])

  depends_on = [
    module.network,
    module.iam,
  ]
}

/* ycr */

module "ycrs" {
  source = "./ycr"
  for_each = {
    for ycr_name, ycr_obj in var.ycrs :
    ycr_name => ycr_obj
    if ycr_obj != null
  }

  folder_id = var.project.folder_id
  name      = try(each.value.name, each.key)
  labels    = try(each.value.labels, {})
  timeouts  = try(each.value.timeouts, null)
  readers = concat(
    try(each.value.readers, []),
    [
      for member in try(each.value.reader_names, []) :
      module.members_ycrs[member].converted
    ]
  )
  writers = concat(
    try(each.value.writers, []),
    [
      for member in try(each.value.writer_names, []) :
      module.members_ycrs[member].converted
    ]
  )
  ip_permissions = try(each.value.ip_permissions, null)
  repositories   = try(each.value.repositories, {})
}
