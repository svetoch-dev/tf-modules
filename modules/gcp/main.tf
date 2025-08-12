module "enable_apis" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-project-factory//modules/project_services?ref=v18.0.0"

  project_id = var.project.id

  activate_apis = var.activate_apis
}


/* network */

module "network" {
  for_each = var.networks
  source   = "./network"

  vpc = {
    name                    = each.value.vpc.name
    project_id              = module.enable_apis.project_id
    description             = try(each.value.vpc.description, "")
    routing_mode            = try(each.value.vpc.routing_mode, "GLOBAL")
    auto_create_subnetworks = try(each.value.vpc.auto_create_subnetworks, false)
  }
  subnets        = each.value.subnets
  routers        = each.value.routers
  ip_addresses   = each.value.ip_addresses
  nat_gws        = each.value.nat_gws
  firewall_rules = each.value.firewall_rules
}


module "gke" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/private-cluster?ref=v36.3.0"
  for_each = {
    for cluster_name, cluster_obj in var.gke_clusters :
    cluster_name => cluster_obj
    if try(cluster_obj.enabled, true) == true
  }
  project_id                      = var.project.id
  deletion_protection             = try(each.value.deletion_protection, true)
  release_channel                 = try(each.value.release_channel, "STABLE")
  kubernetes_version              = each.value.kubernetes_version
  name                            = each.value.name
  regional                        = each.value.regional
  region                          = each.value.region
  zones                           = each.value.zones
  network                         = each.value.network
  subnetwork                      = each.value.subnetwork
  ip_range_pods                   = each.value.ip_range_pods
  ip_range_services               = each.value.ip_range_services
  http_load_balancing             = each.value.http_load_balancing
  horizontal_pod_autoscaling      = each.value.horizontal_pod_autoscaling
  create_service_account          = each.value.create_service_account
  node_metadata                   = each.value.node_metadata
  enable_vertical_pod_autoscaling = each.value.enable_vertical_pod_autoscaling
  enable_shielded_nodes           = each.value.enable_shielded_nodes
  network_policy                  = each.value.network_policy
  network_policy_provider         = each.value.network_policy_provider
  gcs_fuse_csi_driver             = try(each.value.gcs_fuse_csi_driver, false)
  logging_enabled_components = try(
    each.value.logging_enabled_components,
    [
      "SYSTEM_COMPONENTS",
      "WORKLOADS"
    ]
  )

  identity_namespace = each.value.identity_namespace
  cluster_resource_labels = merge(
    each.value.cluster_resource_labels,
    {
      resource_type = "gke_cluster",
      cluster_name  = each.value.name,
    },
  )
  remove_default_node_pool     = each.value.remove_default_node_pool
  authenticator_security_group = each.value.authenticator_security_group

  master_authorized_networks         = each.value.master_authorized_networks
  master_global_access_enabled       = each.value.master_global_access_enabled
  resource_usage_export_dataset_id   = each.value.resource_usage_export_dataset_id
  enable_network_egress_export       = each.value.enable_network_egress_export
  enable_resource_consumption_export = each.value.enable_resource_consumption_export
  enable_private_nodes               = each.value.enable_private_nodes
  enable_private_endpoint            = each.value.enable_private_endpoint
  master_ipv4_cidr_block             = each.value.master_ipv4_cidr_block

  maintenance_start_time = each.value.maintenance_start_time
  maintenance_recurrence = each.value.maintenance_recurrence
  maintenance_end_time   = each.value.maintenance_end_time

  monitoring_enable_managed_prometheus = try(each.value.monitoring.managed_prometheus.enabled, false)
  monitoring_enabled_components        = try(each.value.monitoring.components, ["SYSTEM_COMPONENTS"])
  node_pools                           = each.value.node_pools
  node_pools_oauth_scopes              = each.value.node_pools_oauth_scopes
  node_pools_labels                    = each.value.node_pools_labels
  node_pools_metadata                  = each.value.node_pools_metadata
  node_pools_taints                    = each.value.node_pools_taints
  node_pools_tags                      = each.value.node_pools_tags

  depends_on = [
    module.enable_apis,
    module.network,
    module.iam,
  ]
}

/* cloudsql */

module "cloudsql_postgres" {
  source              = "./cloudsql/postgresql"
  for_each            = var.cloudsql_postgres
  project_id          = var.project.id
  name                = each.key
  database_version    = each.value.postgresql_version
  zone                = each.value.zone
  disk_size           = each.value.settings.disk_size
  disk_type           = each.value.settings.disk_type
  tier                = each.value.settings.tier
  region              = each.value.region
  availability_type   = each.value.settings.availability_type
  deletion_protection = each.value.deletion_protection
  iam_users           = each.value.iam_users
  user_name           = each.value.user.name
  edition             = try(each.value.edition, "ENTERPRISE")
  enable_default_db   = try(each.value.enable_default_db, false)
  user_labels = merge(
    each.value.user_labels,
    {
      resource_type = "cloudsql_database",
      database_name = each.key,
    },
  )

  insights_config = try(each.value.insights_config, null)

  maintenance_window_day          = each.value.maintenance.window_day
  maintenance_window_hour         = each.value.maintenance.window_hour
  maintenance_window_update_track = each.value.maintenance.window_update_track

  backup_configuration = each.value.backup_configuration

  database_flags = each.value.database_flags

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = each.value.network.network_id
    require_ssl         = false
    authorized_networks = each.value.network.authorized_networks
    allocated_ip_range  = each.value.network.allocated_ip_range
  }
  depends_on = [
    module.enable_apis,
    module.network
  ]
}


/* GCS */

module "gcs" {
  source             = "./gcs"
  for_each           = var.gcs
  name               = try(each.value.name, each.key)
  location           = each.value.location
  bucket_policy_only = try(each.value.bucket_policy_only, false)
  storage_class      = try(each.value.storage_class, "STANDARD")
  iam_roles = [
    {
      role    = "roles/storage.objectAdmin"
      members = try(each.value.admins, [])
    },
    {
      role    = "roles/storage.objectCreator"
      members = try(each.value.creators, [])
    },
    {
      role    = "roles/storage.objectViewer"
      members = try(each.value.viewers, [])
    },
    {
      role    = "roles/storage.objectUser"
      members = try(each.value.users, [])
    }
  ]
  force_destroy        = try(each.value.force_destroy, false)
  soft_delete_duration = try(each.value.soft_delete_duration, 604800)
  versioning           = try(each.value.versioning, false)
  lifecycle_rules      = try(each.value.lifecycle_rules, [])
  cors                 = try(each.value.cors, [])
  logging              = try(each.value.logging, null)
  website              = try(each.value.website, null)
  pubsub_notifications = try(each.value.pubsub_notifications, {})
  labels = try(
    each.value.labels,
    {
      resource_type = "gcs_bucket",
      bucket_name   = each.key,
      name          = each.key,
    }
  )
  depends_on = [
    module.enable_apis,
    module.iam,
  ]
}

/* gar */

module "gars" {
  source             = "./gar"
  for_each           = var.gars
  repository_id      = each.key
  location           = each.value.location
  description        = try(each.value.description, "")
  format             = try(each.value.format, "DOCKER")
  mode               = try(each.value.mode, "STANDARD_REPOSITORY")
  readers            = try(each.value.readers, [])
  writers            = try(each.value.writers, [])
  virtual_repository = try(each.value.virtual_repository, null)
  remote_repository  = try(each.value.remote_repository, null)
  depends_on = [
    module.enable_apis,
  ]
}

/* gcr */

module "gcrs" {
  source     = "./gcr"
  for_each   = var.gcrs
  project_id = var.project.id
  registry   = each.value.registry
  pullers    = each.value.pullers
  pushers    = each.value.pushers
  depends_on = [
    module.enable_apis,
  ]
}

/* IAM */

module "iam" {
  source           = "./iam"
  custom_roles     = var.iam.custom_roles
  service_accounts = var.iam.service_accounts
  roles            = var.iam.roles
  project_id       = var.project.id
  depends_on = [
    module.enable_apis,
  ]
}

/* dns */

module "dns" {
  source   = "./dns"
  for_each = var.dns_zones
  zone     = each.value.zone
  records  = each.value.records
  depends_on = [
    module.enable_apis,
  ]
}


/* Memorystore */

module "redis" {
  source         = "./memorystore_redis"
  for_each       = var.redis_instances
  name           = each.value.name
  memory_size_gb = each.value.memory_size_gb
  redis_configs  = each.value.redis_configs
  redis_version  = each.value.redis_version
  tier           = each.value.tier
  auth_enabled   = try(each.value.auth_enabled, "false")
  auth_network   = each.value.auth_network

  depends_on = [
    module.enable_apis,
  ]
}

/* cloudrun */

module "cloudrun_services" {
  source     = "./cloudrun_service"
  for_each   = var.cloudrun_services
  name       = each.value.name
  project_id = var.project.id
  location   = each.value.location
  labels = try(
    each.value.labels,
    null
  )
  request_timeout       = try(each.value.reques_timeout, "300s")
  max_instance_requests = try(each.value.max_instance_requests, 80)
  execution_environment = try(
    each.value.execution_environment,
    "EXECUTION_ENVIRONMENT_GEN2"
  )

  ingress = try(each.value.ingress, "INGRESS_TRAFFIC_ALL")
  members = try(
    each.value.members,
    [
      "allUsers"
    ]
  )
  neg_enabled     = try(each.value.neg_enabled, false)
  container       = each.value.container
  scaling         = each.value.scaling
  service_account = each.value.service_account
  vpc_access      = try(each.value.vpc_access, null)
  volumes         = try(each.value.volumes, {})
  domains         = try(each.value.domains, {})

  depends_on = [
    module.enable_apis,
    module.iam,
  ]
}

module "cloudrun_jobs" {
  source      = "./cloudrun_job"
  for_each    = var.cloudrun_jobs
  name        = each.value.name
  project_id  = var.project.id
  location    = each.value.location
  parallelism = try(each.value.parallelism, 1)
  timeout     = try(each.value.timeout, null)
  max_retries = try(each.value.max_retries, 3)
  labels = try(
    each.value.labels,
    null
  )
  execution_environment = try(
    each.value.execution_environment,
    "EXECUTION_ENVIRONMENT_GEN2"
  )

  containers      = each.value.containers
  service_account = each.value.service_account
  vpc_access      = try(each.value.vpc_access, null)
  volumes         = try(each.value.volumes, {})

  depends_on = [
    module.enable_apis,
    module.iam,
  ]
}

/* albs */

module "application_lbs" {
  source       = "./application_loadbalancer"
  for_each     = var.application_lbs
  name         = each.value.name
  backends     = each.value.backends
  http_target  = each.value.http_target
  https_target = each.value.https_target
}

/* kms */

module "kms" {
  source   = "./kms"
  for_each = var.kms_key_rings
  key_ring = {
    name     = each.value.name
    location = try(each.value.location, var.project.region)
  }
  keys = each.value.keys

  depends_on = [
    module.iam,
  ]
}

/* cloud tasks */

module "cloud_tasks" {
  source        = "./cloud_task"
  for_each      = var.cloud_tasks
  name          = each.value.name
  location      = each.value.location
  rate_limits   = each.value.rate_limits
  retry_configs = each.value.retry_configs
  iam_bindings  = try(each.value.iam_bindings, {})
  logging = try(each.value.logging,
    {
      enabled = false
    }
  )
}

/* cloud scheduler */

module "cloud_schedules" {
  source           = "./cloud_scheduler"
  for_each         = var.cloud_schedules
  name             = each.value.name
  schedule         = each.value.schedule
  description      = try(each.value.description, "")
  timezone         = try(each.value.timezone, "Etc/UTC")
  paused           = try(each.value.paused, false)
  attempt_deadline = try(each.value.attempt_deadline, null)
  retry_configs    = try(each.value.retry_configs, null)
  location         = try(each.value.location, null)
  http_target      = each.value.http_target
}

/* firestore */

module "firestores" {
  source             = "./firestore"
  for_each           = var.firestores
  db                 = each.value.db
  firestore_indecies = try(each.value.firestore_indecies, {})
}

/* vms */

module "vms" {
  source       = "./vm"
  for_each     = var.vms
  project      = var.project
  name         = each.value.name
  machine_type = each.value.machine_type
  disk = try(
    each.value.disk,
    {
      size_gb = 10,
      type    = "pd-balanced"
    }
  )
  network_config = each.value.network_config
  zone           = each.value.zone
  image          = each.value.image
  metadata = try(
    each.value.metadata, {}
  )
  service_account  = each.value.service_account
  tags             = try(each.value.tags, [])
  labels           = try(each.value.labels, {})
  iam_roles        = try(each.value.iam_roles, [])
  additional_disks = try(each.value.additional_disks, [])
}

/* pubsub */

module "pubsub" {
  source                     = "./pubsub"
  for_each                   = var.pubsubs
  name                       = each.key
  message_retention_duration = try(each.value.message_retention_duration, "")
  regions                    = try(each.value.regions, [])
  publishers                 = try(each.value.publishers, [])
  subscribers                = try(each.value.subscribers, [])
  editors                    = try(each.value.editors, [])
  admins                     = try(each.value.admins, [])
  viewers                    = try(each.value.viewers, [])
  subscriptions              = try(each.value.subscriptions, {})
  depends_on = [
    module.enable_apis,
    module.iam,
  ]
}

/* monoitoring */

module "monitoring" {
  source                = "./monitoring"
  log_metrics           = try(var.monitoring.log_metrics, [])
  dashboards            = try(var.monitoring.dashboards, [])
  notification_channels = try(var.monitoring.notification_channels, [])
  alert_policies        = try(var.monitoring.alert_policies, [])
}

/* logging */

module "logging" {
  source     = "./logging"
  log_bucket = try(var.logging.log_bucket, {})
  log_router = try(var.logging.log_router, {})
}

/* allydb */
module "alloydbs" {
  source                           = "./alloydb"
  for_each                         = var.alloydbs
  name                             = each.value.name
  region                           = each.value.region
  database_version                 = each.value.database_version
  initial_user                     = try(each.value.initial_user, null)
  cluster_type                     = try(each.value.cluster_type, "PRIMARY")
  project_id                       = try(each.value.project_id, var.project.id)
  subscription_type                = try(each.value.subscription_type, "STANDARD")
  deletion_policy                  = try(each.value.deletion_policy, "DEFAULT")
  labels                           = try(each.value.labels, {})
  annotations                      = try(each.value.annotations, {})
  encryption_config                = try(each.value.encryption_config, null)
  network_config                   = try(each.value.network_config, null)
  restore_continuous_backup_source = try(each.value.restore_continuous_backup_source, null)
  continuous_backup_config         = try(each.value.continuous_backup_config, null)
  instances                        = try(each.value.instances, {})
  users                            = try(each.value.users, {})
}
