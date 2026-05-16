# yc-v0.10.0

Features:
* `main` ycr outputs
* `ycr` outputs


# yc-v0.9.0

Features:
* `main`: `dns` module 
* `iam/member`: ability to set none default folder_id

# yc-v0.8.0

Features:
* `ycr`: new module

# yc-v0.7.0
Braking changes:
* `main` separate `./iam/member` modules for k8s and s3 members

Features:
* `iam`
  * `service_account` extend module with federated credentials support 
  * `oidc_federation` new module and input variable that create yandex_iam_workload_identity_oidc_federation
* `k8s` 
  * create oidc federation if workload_identity is enabled

Enhancements:
  * `k8s` add name perfix to k8s default sa
  * `iam` service_accounts use name attr for setting name if its set


# yc-v0.6.0
Braking changes
* `k8s/cluster`:
  * use `yandex_kubernetes_cluster_iam_binding` instead of `yandex_kubernetes_cluster_iam_member`
  * disable `serviceAccountName` `userAccountName` lookup interface

* `k8s/node`:
  * `instance_template.network_interface[].subnet_names` argument and logic behind it is removed
* `s3/bucket`:
  * disable `serviceAccountName` `userAccountName` lookup interface

Fixes:
* move `serviceAccountName` `userAccountName` lookup interface in main module

Features:
* `main` `var.k8s{}` and `var.s3{}` can now set `{admin,editor,viewer}_names` vars where userAccountName, serviceAccountName can be used

# yc-v0.5.1

Fixes:
* `k8s` enabled logic


# yc-v0.5.0

Features:
* `s3`: new module

Enhancements:
* `k8s`: enabled logic

# yc-v0.4.0

Braking changes:
* `iam/members -> iam/member` instead of passing a list of members, refactor module to use single member logic and for_each in modules to convert member lists

Features:
* `k8s`: new module

Enhancements:
* update yandex cloud provider 0.189.0 -> 0.195.0

# yc-v0.3.0

Features:
* `iam`: new module
* `iam/roles`: new module
* `iam/service_accounts`: new module
* `iam/members`: new module
* `outputs`: added

# yc-v0.2.0

Features:
* `network`: new module
* `network/ip_address`: new module for `yandex_vpc_address`. Supports all settable attributes + README
* `network/security_group`: new module for `yandex_vpc_security_group`. Supports all settable attributes + README
* `network/vpc`: new module for `yandex_vpc_network`. Supports all settable attributes + README
* `network/gateway`: new module for `yandex_vpc_gateway`. Supports all settable attributes + README
* `network/route_table`: new module for `yandex_vpc_route_table`. Supports all settable attributes + README
* `network/subnet`: new module for `yandex_vpc_subnet`. Supports all settable attributes + README
* `network/ip_address`: new module for `yandex_vpc_address`.Supports all settable attributes + README

# yc-v0.1.0

Features:
* `cloud_config`: submodule
