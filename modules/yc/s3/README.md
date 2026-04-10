# Yandex S3 Module

Creates a Yandex Object Storage bucket and zero or more objects in that bucket.

This composite module orchestrates:
- the `modules/yc/s3/bucket` submodule
- the `modules/yc/s3/object` submodule for each entry in `objects`

## Usage

```hcl
module "s3" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/s3?ref=master"

  name      = "example-bucket"
  folder_id = "b1gxxxxxxxxxxxxxxx"

  force_destroy = true
  versioning    = true

  admins = [
    "serviceAccount:aje0xxxxxxxxxxxxxx",
  ]

  viewers = [
    "userAccount:user@yandex-team.ru",
  ]

  objects = {
    "configs/app.json" = {
      content_type = "application/json"
      content = jsonencode({
        env = "dev"
      })
    }

    logo = {
      name          = "static/logo.svg"
      object_source = "./files/logo.svg"
      content_type  = "image/svg+xml"
    }
  }
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
| `access_key` | The access key used to apply bucket and object changes. | `string` | `null` | no |
| `secret_key` | The secret key used to apply bucket and object changes. | `string` | `null` | no |
| `name_prefix` | Prefix for generating a unique bucket name. | `string` | `null` | no |
| `default_storage_class` | Default storage class for objects in the bucket. | `string` | `"STANDARD"` | no |
| `disabled_statickey_auth` | Whether static key authentication is disabled for the bucket. | `bool` | `null` | no |
| `folder_id` | Folder ID where the bucket will be created. | `string` | `null` | no |
| `force_destroy` | Whether to delete all objects before destroying the bucket. | `bool` | `false` | no |
| `max_size` | Maximum bucket size in bytes. | `number` | `null` | no |
| `policy` | Bucket policy JSON document. | `string` | `null` | no |
| `tags` | Tags assigned to the bucket. | `map(string)` | `null` | no |
| `anonymous_access_flags` | Anonymous access flags for the bucket. | `object` | `null` | no |
| `admins` | IAM member strings that should receive the `storage.admin` role. Must use standard Yandex Cloud IAM member formats such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>`, and similar values accepted by the provider. | `list(string)` | `[]` | no |
| `viewers` | IAM member strings that should receive the `storage.viewer` role. Must use standard Yandex Cloud IAM member formats such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>`, and similar values accepted by the provider. | `list(string)` | `[]` | no |
| `editors` | IAM member strings that should receive the `storage.editor` role. Must use standard Yandex Cloud IAM member formats such as `serviceAccount:<id>`, `userAccount:<login>`, `group:<id>`, and similar values accepted by the provider. | `list(string)` | `[]` | no |
| `cors_rule` | Cross-origin resource sharing rules. | `list(object)` | `[]` | no |
| `https` | HTTPS certificate configuration for the bucket. | `object` | `null` | no |
| `lifecycle_rules` | Lifecycle management rules for bucket objects. | `list(object)` | `[]` | no |
| `logging` | Bucket access logging configuration. | `object` | `null` | no |
| `object_lock_configuration` | Object lock configuration for the bucket. | `object` | `null` | no |
| `server_side_encryption_configuration` | Server-side encryption configuration for the bucket. | `object` | `null` | no |
| `versioning` | While set to true, versioning is fully enabled for this bucket. | `bool` | `false` | no |
| `website` | Static website hosting configuration. | `object` | `null` | no |
| `objects` | Map of objects to create in the bucket. Map keys are used as default object names when `objects[*].name` is omitted. | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `bucket` | The created bucket resource. |
| `objects` | Map of created object resources keyed by the `objects` input map key. |

## Notes

- This module creates one bucket and then creates all entries from `objects` inside that bucket.
- `admins`, `editors`, and `viewers` are converted into bucket IAM bindings internally.
- Each object can set only one of `content`, `content_base64`, or `object_source`.
- Each object must set `object_lock_mode` and `object_lock_retain_until_date` together.
- If `objects[*].name` is omitted, the object name defaults to the map key.

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

### `server_side_encryption_configuration`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `rule` | `object` | yes | SSE rule configuration. |

### `website`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `error_document` | `string` | no | Error document path for website hosting. |
| `index_document` | `string` | no | Index document path for website hosting. |
| `redirect_all_requests_to` | `string` | no | Redirect target for all requests. |
| `routing_rules` | `string` | no | Routing rules JSON string. |

### `objects[KEY]`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | no | Object name override. Defaults to the map key. |
| `acl` | `string` | no | Predefined ACL to apply to the object. |
| `content` | `string` | no | Literal UTF-8 content to upload. |
| `content_base64` | `string` | no | Base64-encoded content to upload. |
| `content_type` | `string` | no | MIME type describing the object data. |
| `object_lock_legal_hold_status` | `string` | no | Legal hold status for the object. |
| `object_lock_mode` | `string` | no | Object lock mode. Must be set with `object_lock_retain_until_date`. |
| `object_lock_retain_until_date` | `string` | no | RFC3339 timestamp until which the object is locked. |
| `object_source` | `string` | no | Path to a file to upload. |
| `object_source_hash` | `string` | no | Hash of the source content used to trigger updates. |
| `tags` | `map(string)` | no | Tags assigned to the object. |
