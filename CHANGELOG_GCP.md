# gcp-v2.8.2
Enhancements:
* `all modules` - try to create only none null objects


# gcp-v2.8.1
Enhancements:
* `cloudrun_service` - ability to set deletion_protection attr

Fixes:
* `gcs` - gcs main.tf module name labels now have the same logic as name attr

# gcp-v2.8.0

Features:
* `networking` - use own vpc module
* `networking/vpc/peering` - new vpc peering module


# gcp-v2.7.0

Features:
* `logging` - `log_audit` module for enabling audit logs

Enhancements:
* `logging`
  * `depends_on` for logging modules
  * use `var.project_id` instead of datasource in order to use `depends_on` in modules

# gcp-v2.6.3

Enhancements:
* `cloudrun_service` - request timeout attribute

# gcp-v2.6.2

Enhancements:
* `cloudsql_postgres` - `edition` defaults to `ENTERPRISE`

# gcp-v2.6.1

Enhancements:
* `cloudsql_postgres` - `enable_default_db` defaults to false

# gcp-v2.6.0

Features:
* `cloudsql_postgres` - generate password in `cloudsql/postgres` module

Enhancements:
* `cloudsql/postgres` - copy of public module

# gcp-v2.5.1

Enhancements:
* `cloud_schedules` - settable region attribute

# gcp-v2.5.0

Enhancements:
* alloydb initial user support

# gcp-v2.4.0

Features:
* cloudrun job module

# gcp-v2.3.0

Features
* alloydb gcp module
* update google/google-beta providers to `6.40.0`

# gcp-v2.2.0

Features
* update module `gke` v36.1.0 -> v36.3.0
* add ability to set release_channel for 'gke'
* change default 'REGULAR' release_channel to 'STABLE' (improve stability)

# gcp-v2.1.1

Fixes:
* `gcp/gcs/force_destroy` the value of the variable was not transmitted

# gcp-v2.1.0

features:
* `gcp/logging`: added logging module for logging configuration in gcp
* `gcp/logging/log_bucket`: we can create custom buckets for logs
* `gcp/logging/log_router`: we can create sinks for routing logs to different log buckets


# gcp-v2.0.0

BrakingChanges:
* Removal of `gcp/firestore/datastore_indices`

Features
* `google`, `google-beta` providers updated to 6.27.0
* third party modules update
  * `google-project-factory` v14.5.0 -> v18.0.0
  * `gke` v30.2.0 -> v36.1.0
  * `postgresql` v22.1.0 -> v25.2.2
  * `terraform-google-network` v9.0.0 -> v10.0.0
  * `terraform-google-cloud-route` v6.0.2 -> v6.3.0
  * `terraform-google-cloud-nat` v5.0.0 -> v5.3.0
  * `terraform-google-vm` v12.0.0 -> v13.2.4
* `gcp/monitoring/alert_policy` - `notification_prompts` attr for `alert_strategy` var 


Enhancements:
* `versions.tf` file in all modules

fixes:
* lint

# gcp-v1.8.1

features:
* `gcp/monitoring/alert_policy`: added block for documentation about policy

fixes: 
* `gcp/monitoring/alert_policy`: auto_close param has wrong naming
  
# gcp-v1.8.0

features:
* `gcp/monitoring`: added notification channels and alerting modules for gcp

fixes: 
* `gcp/monitoring/dashboards`: fixed the default alignment period. Because if default value is used, tf will add this field every time

# gcp-v1.7.2

features:
* `gcp/gke`: gcsfuse csi driver support

# gcp-v1.7.1

features:
* `gcp`: output vm attributes

# gcp-v1.7.0

features:
* `gcp/firestore/firestore_index`: added firestore index module to firestore in gcp

# gcp-v1.6.1

fixes:
* `monitoring/dashboards`: changed  goupByFields field default from [] to null
* `datastore indecies`: changed indexies job timeouts default from 50 minutes to 90 minutes for create/delete operations

# gcp-v1.6.0

features:
  * `gke`:
    * `enabled` flag
    * `deletion_protection` attribute

# gcp-v1.5.2

fixes:
* `monitoring/dashboards`: added if statements to delete unnecessary fields in dashboards
* `datastore indecies`: added indexies job timeouts (default 50 minutes for create/delete operations) 

# gcp-v1.5.1

fixes:
* `monitoring/dashboards`: use `templatefile` because `registry.terraform.io/hashicorp/template` provider in depricated and dosent support darwin_arm64 packages
* `cloudsql`: pin version of cloudsql module to v22.1.0

# gcp-v1.5.0

features:
* `gcs`: added new role 'storage.objectUser'
fixes:
* `gcs`: fixed creation of empty google_storage_bucket_iam_building resources. (when executing terraform apply, you will be prompted to delete empty resources)

# gcp-v1.4.1

features:
* `gcs`: ability to set `retention_duration_seconds` for `soft_delete_policy` using variable `soft_delete_duration`
fixes:
* `monitoring`: fix `var.monitoring is object with no attributes`


# gcp-v1.4.0

Added `monitoring` module:
 - ability to creating `log based metrics`
 - ability to creating `dashboards`

# gcp-v1.3.2

fixes:
* `pubsub`: var.subscriptions is null. (The given "for_each" argument value is unsuitable: the given "for_each" argument value is null. A map, or set of strings is allowed.)


# gcp-v1.3.1

Enhancements:
* `vm`: ability to specify `auto_delete` property of attached additional disks

# gcp-v1.3.0

features:
* `vm`: ability to attach additional disks

# gcp-v1.2.1

fixes:
* `vm`: create public ip in same region as vm

# gcp-v1.2.0

features:
* `vm`: iam roles

# gcp-v1.1.4

Enhancements:
* `gcp`: use `any` as inputs to gcp module to avoid `all map elements must have the same type.` errors
* `network`: use `any` as input for firewall rules module to avoid `all map elements must have the same type.` errors
* `vm`: default `[]` for `service_account.roles` input

# gcp-v1.1.3

Enhancements:
* `firestore`: Added the ability to use backups in firestore

# gcp-v1.1.2

Enhancements:
* `cloud_tasks`: add logging

# gcp-v1.1.1

features:
* `network`: nat gws new attributes (max/min port per vm + `enable_dynamic_port_allocation`)

# gcp-v1.1.0

features:
* `network`: create nat gws only for specific subnetworks

# gcp-v1.0.8

Enhancements:
* `cloudrun`: the ability to set labels

# gcp-v1.0.7

Enhancements:
* `network/firewall-rules`: additional `source_service_accounts`, `source_tags` attrs

# gcp-v1.0.6

Fixes:
* `pubsub`: fix the `max_delivery_attempt` value was reset with each terraform apply

# gcp-v1.0.5

* `cloudrun`: add `max_instance_requests` attribute to control max cloudrun concurrent requests
