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
