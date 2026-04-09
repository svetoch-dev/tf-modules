module "bucket" {
  source = "./bucket"

  access_key                           = var.access_key
  secret_key                           = var.secret_key
  name                                 = var.name
  name_prefix                          = var.name_prefix
  default_storage_class                = var.default_storage_class
  disabled_statickey_auth              = var.disabled_statickey_auth
  folder_id                            = var.folder_id
  force_destroy                        = var.force_destroy
  max_size                             = var.max_size
  policy                               = var.policy
  tags                                 = var.tags
  anonymous_access_flags               = var.anonymous_access_flags
  cors_rule                            = var.cors_rule
  https                                = var.https
  lifecycle_rules                      = var.lifecycle_rules
  logging                              = var.logging
  object_lock_configuration            = var.object_lock_configuration
  server_side_encryption_configuration = var.server_side_encryption_configuration
  versioning                           = var.versioning
  website                              = var.website
  iam_roles = concat(
    length(var.admins) != 0 ? [
      {
        role    = "storage.admin"
        members = var.admins
      },
    ] : [],
    length(var.editors) != 0 ? [
      {
        role    = "storage.editor"
        members = var.editors
      },
    ] : [],
    length(var.viewers) != 0 ? [
      {
        role    = "storage.viewer"
        members = var.viewers
      },
    ] : []
  )
}

module "objects" {
  source   = "./object"
  for_each = var.objects

  access_key                    = var.access_key
  secret_key                    = var.secret_key
  bucket                        = module.bucket.this.bucket
  name                          = each.value.name == null ? each.key : each.value.name
  acl                           = each.value.acl
  content                       = each.value.content
  content_base64                = each.value.content_base64
  content_type                  = each.value.content_type
  object_lock_legal_hold_status = each.value.object_lock_legal_hold_status
  object_lock_mode              = each.value.object_lock_mode
  object_lock_retain_until_date = each.value.object_lock_retain_until_date
  object_source                 = each.value.object_source
  object_source_hash            = each.value.object_source_hash
  tags                          = each.value.tags
}
