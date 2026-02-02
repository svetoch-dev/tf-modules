output "vpcs" {
  value = try(
    module.gcp.vpcs,
    null
  )
}
