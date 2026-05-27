# rod-v0.22.0

Features:
* new `env.test` input attribute. If its set a random suffix is added to gcp custom roles. This is needed because custom roles are permanently deleted only after 1 month and during this period of time you can't use the same role name. Which brakes our testing envs where we create and delete envs all the time

# rod-v0.21.0

Breaking changes:
* `cloud/gcp` devide module into internal/product submodules
* `cloud/yc` devide module into internal/product submodules
* `k8s` devide module into internal/product submodules

Features:
* `cloud/yc`:
   * logic that checks if subnet names from local.yc_network_merged are set in `local.local.yc_k8s_clusters_merged.<cluster>.node_groups.<node_group>.instance_template.network_interface[<index>].subnet_ids` if they are it gets the subnet_ids from module outputs
   * logic checks if "k8s_federation_id" str is set in `local.yc_iam_merged.service_accounts[<sa_name>].federated_credentias[<name>].federation_id` if it is than it gets federation id from k8s cluster

# rod-v0.20.0

Features:
* `cloud/gcp` registries output
* `cloud/yc` registries output

Enhancements:
* `cloud/gcp` removed legacy lookup code in outputs

# rod-v0.19.1
Fixes:
* `k8s` fix argocd role binding for yc

# rod-v0.19.0

Features:
* new `ci` module

Fixes:
* `inputs` fix missing var.env.cloud.folder_id attribute

# rod-v0.18.0

Features:
* common input.tf for all modules
* common input new var.env.dns and var.env.registry attibutes
* set domain zone name to one set in var.env.dns.domain

# rod-v0.17.1
Fixes:
* `cloud/gcp` fixes for new gke clusters

# rod-v0.17.0

Features:
* `cloud/yc`
  * dns support
  * get int sa ids using `serviceAccountName:${var.int_env.cloud.folder_id}:runner-int` strings instead of data source

# rod-v0.16.1

Fixes:
* `cloud/gcp/output.tf` fix outputs: extend default k8s_clusters output with ca_certificate and endpoint parameters

# rod-v0.16.0

Features:
* `cloud/gcp/gcp_k8s_clusters_variables.tf` use own GKE module [gcp-v3.0.0-alpha-1](CHANGELOG_GCP.md#gcp-v3.0.0-alpha-1)

# rod-v0.15.0

Features:
* `cloud/yc` create default `container` registry

# rod-v0.14.0

Braking Changes:
* `cloud/yc`
  * create k8s yandex service accounts inside k8s module


Fixes:
* `cloud/yc`
  * service accounts add env short name prefix
  * change the release_channel to RAPID

Features:
* `cloud/yc`
  * add federated credentials to service accounts


# rod-v0.13.1

[yc-v0.5.1](CHANGELOG_YC.md#yc-v051)

# rod-v0.13.0

Features:
* `rod/cloud/yc` s3 support 

# rod-v0.12.0

Features:
* `rod/cloud/yc` k8s support 
* `rod/cloud/k8s` yc support 

# rod-v0.11.0

Features:
* `rod/cloud/yc` iam support 

# rod-v0.10.0

Features:
* `rod/cloud/yc` network support

# rod-v0.9.2

[gcp-v2.8.6](CHANGELOG_GCP.md#gcp-v286)

# rod-v0.9.1
Fixes:
* `rod/repos` module - required provider has been added

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
