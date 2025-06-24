output "user" {
  description = "Alloy db user"
  value = merge(
    google_alloydb_user.user,
    {
    }
  )
}
