module "zone" {
  source = "./zone"

  folder_id           = var.folder_id
  name                = var.name
  zone                = var.zone
  description         = var.description
  labels              = var.labels
  public              = var.public
  private_networks    = var.private_networks
  deletion_protection = var.deletion_protection
  iam_roles = concat(
    #Yandex provider does not accept empty members lists
    length(var.admins) != 0 ? [
      {
        role    = "dns.admin"
        members = var.admins
      },
    ] : [],
    length(var.editors) != 0 ? [
      {
        role    = "dns.editor"
        members = var.editors
      },
    ] : [],
    length(var.viewers) != 0 ? [
      {
        role    = "dns.viewer"
        members = var.viewers
      },
    ] : []
  )
  timeouts = var.timeouts
}

module "records" {
  source = "./record"
  for_each = {
    for record_obj in var.records :
    record_obj.name => record_obj
    if record_obj != null
  }

  zone_id     = module.zone.this.id
  name        = each.value.name
  type        = each.value.type
  description = each.value.description
  ttl         = each.value.ttl
  data        = each.value.data
  timeouts    = each.value.timeouts
}
