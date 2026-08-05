resource "mongodbatlas_team" "this" {
  org_id    = local.team.org_id
  name      = local.team.name
  usernames = local.team.usernames
}
