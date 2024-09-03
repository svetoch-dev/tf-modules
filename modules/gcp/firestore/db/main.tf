resource "google_firestore_database" "this" {
  count                             = var.app_engine.create == false ? 1 : 0
  name                              = var.name
  location_id                       = var.location_id
  type                              = var.type
  concurrency_mode                  = var.concurrency_mode
  app_engine_integration_mode       = var.app_engine.integration_mode
  delete_protection_state           = var.delete_protection_state
  deletion_policy                   = var.deletion_policy
  point_in_time_recovery_enablement = var.backup.pitr == true ? "POINT_IN_TIME_RECOVERY_ENABLED" : "POINT_IN_TIME_RECOVERY_DISABLED"
}


resource "google_app_engine_application" "this" {
  count         = var.app_engine.create == true ? 1 : 0
  project       = data.google_project.project.project_id
  location_id   = var.location_id
  database_type = var.type
}


resource "google_firestore_backup_schedule" "daily-backup" {
  count     = var.backup.daily_bp == true ? 1 : 0
  project   = data.google_project.project.project_id
  database  = google_firestore_database.this[0].name
  retention = var.backup.retention

  daily_recurrence {}
}

resource "google_firestore_backup_schedule" "weekly-backup" {
  count     = var.backup.weekly_bp == true ? 1 : 0
  project   = data.google_project.project.project_id
  database  = google_firestore_database.this[0].name
  retention = var.backup.retention

  weekly_recurrence {
    day = var.backup.recurrence_day
  }
}

data "google_project" "project" {}
