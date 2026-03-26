locals {
  #For service accounts we need to get thier ids
  #so we 
  #1. introduce a nonexistant subject prefix
  #serviceAccountName
  #2. If we find this prefix in members we lookup sa
  #ids in module.service_accounts
  iam_roles = {
    for role_name, role_obj in var.iam.roles :
    role_name => merge(
      role_obj,
      {
        members = concat(
          #First form list of all members withour serviceAccountName:
          [
            for member in role_obj.members :
            member
            if !strcontains(member, "serviceAccountName:")
          ],
          [
            for member in role_obj.members :
            "serviceAccount:${module.iam.service_accounts[trimprefix(member, "serviceAccountName:")].id}"
            if strcontains(member, "serviceAccountName:")
          ]
        )
      }
    )
  }
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
  roles            = local.iam_roles
  folder_id        = var.project.folder_id
}
