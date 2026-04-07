# Yandex S3 Object Module

Creates a single object in a Yandex Object Storage bucket.

## Usage

```hcl
module "object" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/s3/object?ref=master"

  bucket = "example-bucket"
  name   = "configs/app.json"

  content_type = "application/json"
  content = jsonencode({
    env = "dev"
  })

  tags = {
    team = "platform"
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
| `bucket` | The name of the containing bucket. | `string` | n/a | yes |
| `name` | The name of the object once it is in the bucket. | `string` | n/a | yes |
| `access_key` | The access key used to apply object changes. | `string` | `null` | no |
| `secret_key` | The secret key used to apply object changes. | `string` | `null` | no |
| `acl` | The predefined ACL to apply. | `string` | `null` | no |
| `content` | Literal UTF-8 content to upload. Conflicts with `content_base64` and `object_source`. | `string` | `null` | no |
| `content_base64` | Base64-encoded content to upload. Conflicts with `content` and `object_source`. | `string` | `null` | no |
| `content_type` | MIME type describing the object data. | `string` | `null` | no |
| `object_lock_legal_hold_status` | Legal hold status for the object. | `string` | `null` | no |
| `object_lock_mode` | Object lock mode. Must be set together with `object_lock_retain_until_date`. | `string` | `null` | no |
| `object_lock_retain_until_date` | RFC3339 timestamp until which the object is locked. Must be set together with `object_lock_mode`. | `string` | `null` | no |
| `object_source` | Path to a file to upload. Conflicts with `content` and `content_base64`. | `string` | `null` | no |
| `object_source_hash` | Hash of the source content used to trigger updates when `object_source` changes. | `string` | `null` | no |
| `tags` | Tags assigned to the object. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The created storage object resource. |

## Notes

- Set only one of `content`, `content_base64`, or `object_source`.
- If you use object retention, set both `object_lock_mode` and `object_lock_retain_until_date`.
- `object_source_hash` is useful when the local file content changes but Terraform would not otherwise detect it reliably from `object_source` alone.
