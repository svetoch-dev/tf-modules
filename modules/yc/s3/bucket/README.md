# Yandex S3 Bucket Module

Creates a Yandex Object Storage bucket and manages related bucket configuration resources.

This module creates:
- a `yandex_storage_bucket`
- an optional `yandex_storage_bucket_grant`
- an optional `yandex_storage_bucket_policy`
- zero or more `yandex_storage_bucket_iam_binding` resources

## Usage

```hcl
module "bucket" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/s3/bucket?ref=master"

  name      = "example-bucket"
  folder_id = "b1gxxxxxxxxxxxxxxx"

  force_destroy         = true
  default_storage_class = "STANDARD"
  versioning            = true

  anonymous_access_flags = {
    read = false
    list = false
  }

  cors_rule = [
    {
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["https://example.com"]
      max_age_seconds = 3600
    }
  ]

  iam_roles = [
    {
      role = "storage.viewer"
      members = [
        "userAccount:user@yandex-team.ru",
      ]
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| yandex | 0.195.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | The bucket name. | `string` | n/a | yes |
| `access_key` | The access key used to apply bucket changes. By default, IAM token authentication is used. | `string` | `null` | no |
| `secret_key` | The secret key used to apply bucket changes. By default, IAM token authentication is used. | `string` | `null` | no |
| `name_prefix` | Prefix for generating a unique bucket name. | `string` | `null` | no |
| `default_storage_class` | Default storage class for objects in the bucket. | `string` | `"STANDARD"` | no |
| `disabled_statickey_auth` | Whether static key authentication is disabled for the bucket. | `bool` | `null` | no |
| `folder_id` | Folder ID where the bucket will be created. | `string` | `null` | no |
| `force_destroy` | Whether to delete all objects before destroying the bucket. | `bool` | `false` | no |
| `max_size` | Maximum bucket size in bytes. | `number` | `null` | no |
| `policy` | Bucket policy JSON document. Managed through `yandex_storage_bucket_policy`. | `string` | `null` | no |
| `tags` | Tags assigned to the bucket. | `map(string)` | `null` | no |
| `anonymous_access_flags` | Anonymous access flags for the bucket. | `object` | `null` | no |
| `cors_rule` | Cross-origin resource sharing rules. | `list(object)` | `[]` | no |
| `grant` | ACL grants for the bucket. Managed through `yandex_storage_bucket_grant`. | `list(object)` | `[]` | no |
| `https` | HTTPS certificate configuration for the bucket. | `object` | `null` | no |
| `lifecycle_rules` | Lifecycle management rules for bucket objects. | `list(object)` | `[]` | no |
| `logging` | Bucket access logging configuration. | `object` | `null` | no |
| `object_lock_configuration` | Object lock configuration for the bucket. | `object` | `null` | no |
| `server_side_encryption_configuration` | Server-side encryption configuration for the bucket. | `object` | `null` | no |
| `versioning` | While set to true, versioning is fully enabled for this bucket. | `bool` | `false` | no |
| `website` | Static website hosting configuration. | `object` | `null` | no |
| `iam_roles` | IAM role bindings for the bucket. | `list(object)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The created bucket resource. |

## Notes

- `policy` is managed through a separate `yandex_storage_bucket_policy` resource.
- `grant` is managed through a separate `yandex_storage_bucket_grant` resource.
- `iam_roles` are converted into `yandex_storage_bucket_iam_binding` resources and are applied with the member strings provided to the module.
- `versioning` is exposed as a simple boolean and is rendered as a `versioning` block internally.

## Type Details

### `anonymous_access_flags`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `config_read` | `bool` | no | Allow anonymous reads of bucket configuration. |
| `list` | `bool` | no | Allow anonymous listing of bucket contents. |
| `read` | `bool` | no | Allow anonymous reads of objects. |

### `cors_rule[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `allowed_headers` | `list(string)` | no | Allowed request headers. |
| `allowed_methods` | `list(string)` | yes | Allowed HTTP methods. |
| `allowed_origins` | `list(string)` | yes | Allowed origins. |
| `expose_headers` | `list(string)` | no | Response headers exposed to browsers. |
| `max_age_seconds` | `number` | no | Browser cache time for preflight responses. |

### `grant[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `id` | `string` | no | Canonical user ID for the grant. |
| `permissions` | `set(string)` | yes | Permissions assigned by the grant. |
| `type` | `string` | yes | Grant subject type. |
| `uri` | `string` | no | Group URI for the grant. |

### `https`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `certificate_id` | `string` | yes | Certificate Manager certificate ID used for HTTPS. |

### `lifecycle_rules[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `abort_incomplete_multipart_upload_days` | `number` | no | Days before incomplete multipart uploads are aborted. |
| `enabled` | `bool` | yes | Whether the lifecycle rule is enabled. |
| `id` | `string` | no | Lifecycle rule identifier. |
| `prefix` | `string` | no | Object key prefix matched by the rule. |
| `expiration` | `object` | no | Expiration behavior. |
| `filter` | `object` | no | Advanced object filter. |
| `noncurrent_version_expiration` | `object` | no | Expiration settings for noncurrent versions. |
| `noncurrent_version_transition` | `object` | no | Storage class transition for noncurrent versions. |
| `transition` | `object` | no | Storage class transition for current versions. |

### `lifecycle_rules[].expiration`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `date` | `string` | no | Expire matching objects on this date. |
| `days` | `number` | no | Expire matching objects after this many days. |
| `expired_object_delete_marker` | `bool` | no | Remove expired object delete markers. |

### `lifecycle_rules[].filter`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `object_size_greater_than` | `number` | no | Minimum object size to match. |
| `object_size_less_than` | `number` | no | Maximum object size to match. |
| `prefix` | `string` | no | Object key prefix to match. |
| `and` | `object` | no | Composite filter conditions. |
| `tag` | `object` | no | Single object tag filter. |

### `lifecycle_rules[].filter.and`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `object_size_greater_than` | `number` | no | Minimum object size to match. |
| `object_size_less_than` | `number` | no | Maximum object size to match. |
| `prefix` | `string` | no | Object key prefix to match. |
| `tags` | `map(string)` | no | Tag set that must match. |

### `lifecycle_rules[].filter.tag`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `key` | `string` | yes | Tag key to match. |
| `value` | `string` | yes | Tag value to match. |

### `lifecycle_rules[].noncurrent_version_expiration`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `days` | `number` | yes | Days until a noncurrent version expires. |

### `lifecycle_rules[].noncurrent_version_transition`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `days` | `number` | yes | Days until a noncurrent version transitions. |
| `storage_class` | `string` | yes | Target storage class for the transition. |

### `lifecycle_rules[].transition`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `date` | `string` | no | Transition matching objects on this date. |
| `days` | `number` | no | Transition matching objects after this many days. |
| `storage_class` | `string` | yes | Target storage class for the transition. |

### `logging`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `target_bucket` | `string` | yes | Bucket receiving access logs. |
| `target_prefix` | `string` | no | Prefix for log object names. |

### `object_lock_configuration`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `object_lock_enabled` | `string` | yes | Enables object lock for the bucket. |
| `rule` | `object` | no | Default retention configuration. |

### `object_lock_configuration.rule`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `default_retention` | `object` | yes | Default retention applied to new objects. |

### `object_lock_configuration.rule.default_retention`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `days` | `number` | no | Retention period in days. |
| `mode` | `string` | yes | Retention mode. |
| `years` | `number` | no | Retention period in years. |

### `server_side_encryption_configuration`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `rule` | `object` | yes | SSE rule configuration. |

### `server_side_encryption_configuration.rule`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `apply_server_side_encryption_by_default` | `object` | yes | Default SSE behavior. |

### `server_side_encryption_configuration.rule.apply_server_side_encryption_by_default`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `kms_master_key_id` | `string` | yes | KMS key ID used for encryption. |
| `sse_algorithm` | `string` | yes | Server-side encryption algorithm. |

### `website`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `error_document` | `string` | no | Error document path for website hosting. |
| `index_document` | `string` | no | Index document path for website hosting. |
| `redirect_all_requests_to` | `string` | no | Redirect target for all requests. |
| `routing_rules` | `string` | no | Routing rules JSON string. |

### `iam_roles[]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `role` | `string` | yes | Bucket IAM role to assign. |
| `members` | `list(string)` | yes | Members that should receive the role. Must use standard Yandex Cloud IAM member formats accepted by the provider. |
