# yc-v0.4.0

Braking changes:
* `network/members -> network/member` instead of passing a list of members, refactor module to use single member logic and for_each in modules to convert member lists

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
