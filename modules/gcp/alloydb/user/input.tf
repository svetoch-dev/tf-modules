variable "user_id" {
  description = "Alloydb user id"
  type        = string
}

variable "cluster" {
  description = "Alloydb cluster id projects/{project}/locations/{location}/clusters/{cluster_id}'"
  type        = string
}

variable "user_type" {
  description = "Alloydb user type ALLOYDB_BUILT_IN/ALLOYDB_IAM_USER."
  type        = string
}

variable "database_roles" {
  description = "Postgres db roles of the user"
  type        = list(string)
}

variable "password" {
  description = "User password. Only applicable to ALLOYDB_BUILT_IN user type. If not set random password is generated"
  type        = string
  default     = null
}
