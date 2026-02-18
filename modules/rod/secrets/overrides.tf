locals {
  secrets_merged = provider::deepmerge::mergo(local.secrets, var.overrides.secrets)
}
