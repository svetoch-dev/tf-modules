locals {
  public_ip        = var.network_config.public_ip
  create_static_ip = local.public_ip == null ? false : !local.public_ip.ephemeral
}

module "template" {
  source = "git::https://git@github.com/terraform-google-modules/terraform-google-vm.git//modules/instance_template?ref=v11.1.0"

  machine_type = var.machine_type
  disk_size_gb = tostring(var.disk.size_gb)
  disk_type    = var.disk.type
  subnetwork   = var.network_config.subnet
  service_account = {
    email  = var.service_account.email != null ? var.service_account.email : module.service_account[0].service_account.email
    scopes = var.service_account.scopes
  }
  source_image         = var.image.name
  source_image_project = var.image.project
  source_image_family  = var.image.family
  metadata             = var.metadata

  tags = var.tags
}

module "service_account" {
  source          = "../iam/service_account"
  count           = var.service_account.email != null ? 0 : 1
  name            = var.service_account.name
  project_id      = var.project_id
  description     = var.service_account.description
  roles           = var.service_account.roles
  sa_iam_bindings = var.service_account.sa_iam_bindings
  generate_key    = false
}

resource "google_compute_instance_from_template" "this" {
  name                     = var.name
  zone                     = var.zone
  source_instance_template = module.template.self_link
  network_interface {
    subnetwork = var.network_config.subnet
    access_config = local.public_ip == null ? [] : [
      {
        nat_ip                 = local.public_ip.ephemeral == true ? null : google_compute_address.public_ip[local.public_ip.static.name].address
        network_tier           = local.public_ip.network_tier
        public_ptr_domain_name = ""
      }
    ]
  }
}

resource "google_compute_address" "public_ip" {
  for_each = local.create_static_ip == false ? {} : {
    "${local.public_ip.static.name}" = local.public_ip.static
  }
  name        = each.value.name
  region      = replace(var.zone, "/-[a-z]/", "")
  description = each.value.description
}

resource "google_compute_instance_iam_binding" "this" {
  for_each = {
    for iam_role_obj in var.iam_roles :
    iam_role_obj.role => iam_role_obj
  }
  instance_name = google_compute_instance_from_template.this.name
  role          = each.value.role
  members       = each.value.members
}
