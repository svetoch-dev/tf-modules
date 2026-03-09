# rod-v0.9.0
Features:
* `rod/repos` module


# rod-v0.8.0
Features:
* `rod/secrets` module


# rod-v0.7.0
Features:
* `rod/cloud/gcp`: 
  * `var.env` users attribute
  * `var.env.apps` access_roles attribute to set what role can access app
  * grant developers custom gcp role to users with dev role
  * grant owners gcp role to users with admin role
* `rod/k8s`: 
  * `var.env` users attribute
  * `var.env.apps` access_roles attribute to set what role can access app
* `rod/cloud/yc`: initial commit

Fixes:
* `yc/client_config` fix provider inputs and vars


# rod-v0.6.1
Fixes:
* `rod/cloud/gcp`: runners-cache bucket `bucket_policy_only   = true`


# rod-v0.6.0
Braking changes:
* `rod/cloud/gcp`: var.apps moved under var.env
* `rod/k8s`: var.apps moved under var.env

Features:
* `rod/cloud/gcp`:
  * runners-cache bucket
  * white list gcp ips needed for IAP
  * iam:postgres:workload_identity: create only if app has `postgres = true`

Enhancements:
* `rod/cloud/gcp`: logs bucket use `soft_deletion_retention = 0` 


# rod-v0.5.0
Braking changes:
* `rod/cloud/gcp` remove provider_config input

Enhancement:
* `rod/cloud/gcp` apps input remove defaults


# rod-v0.4.0
Features:
* `rod/cloud` moved to `rod/cloud/gcp`
* `rod/cloud/gcp` add `int only` logic to resources


# rod-v0.3.0
Features:
* `rod/k8s` module


# rod-v0.2.0
Features:
* `rod/cloud`:
  * new attribute `var.env.cloud.buckets.multi_regional` that controlls if the buckets are created in multiple regions
  * new attribute `var.env.kubernetes.node_locations` that controlls in which zones nodes can be create
  * remove grafana sa
  * fix issue with disabling a node pool via overrides
  * do not pin provider versions
  * output `k8s_clusters` info
  * output `iam` info
  * use lookup function to choose which cloud module should be outputed


# rod-v0.1.0
Features:
* `rod/cloud` module
