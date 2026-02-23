# rod-v0.5.0

BrakingCahge:
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
