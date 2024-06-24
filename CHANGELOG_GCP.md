# gcp-v1.0.7

Enhancements:
* `network/firewall-rules`: additional `source_service_accounts`, `source_tags` attrs


# gcp-v1.0.6

Fixes:
* `pubsub`: fix the `max_delivery_attempt` value was reset with each terraform apply

# gcp-v1.0.5

* `cloudrun`: add `max_instance_requests` attribute to control max cloudrun concurrent requests
