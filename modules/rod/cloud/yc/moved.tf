# Preserve the existing YC service account resources when aligning the key with the KSA.
moved {
  from = module.yc.module.iam.module.service_accounts["vedro"]
  to   = module.yc.module.iam.module.service_accounts["vedrosa"]
}
