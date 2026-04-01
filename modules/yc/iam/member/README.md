# Yandex IAM Member Conversion Module

Converts a single Yandex Cloud IAM member string into a normalized value that can be used by other modules.

The module passes regular IAM member values through unchanged and resolves two convenience aliases:

- `serviceAccountName:<name>` resolves a service account name into `serviceAccount:<id>`.
- `userAccountName:<login>` resolves a user login into `userAccount:<id>`.

## Usage

```hcl
module "iam_member" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam/member?ref=master"

  member = "serviceAccountName:ci-runner"
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
| `member` | IAM member string. Standard Yandex Cloud IAM member values are kept as-is. `serviceAccountName:<name>` and `userAccountName:<login>` are resolved through Yandex Cloud data sources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `converted` | Normalized IAM member after resolving supported aliases. |

## Notes

- Values without `serviceAccountName:` or `userAccountName:` are returned unchanged.
- `serviceAccountName:<name>` resolves through the `yandex_iam_service_account` data source and returns `serviceAccount:<id>`.
- `userAccountName:<login>` resolves through the `yandex_iam_user` data source and returns `userAccount:<id>`.
- The module converts exactly one member value per invocation.
