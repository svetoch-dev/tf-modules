output "vpcs" {
  value = merge(
    var.env.cloud.name == "gcp" ? module.gcp.vpcs : {},
  )
}
