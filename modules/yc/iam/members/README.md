# Yandex IAM Members Conversion Module

Converts a list of Yandex Cloud IAM member strings into a normalized list that can be used by other modules.

The module passes regular IAM member values through unchanged and resolves two convenience aliases:

- `serviceAccountName:<name>` resolves a service account name into `serviceAccount:<id>`.
- `userAccountName:<login>` resolves a user login into `userAccount:<id>`.

## Usage

```hcl
module "iam_members" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam/members?ref=master"

  members = [
    "serviceAccountName:ci-runner",
    "userAccountName:user@yandex-team.ru",
    "group:aje0xxxxxxxxxxxxxx",
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| yandex | 0.189.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `members` | List of IAM member strings. Standard Yandex Cloud IAM member values are kept as-is. `serviceAccountName:<name>` and `userAccountName:<login>` are resolved through Yandex Cloud data sources. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `converted` | Normalized list of IAM members after resolving supported aliases. |

## Notes

- Entries that do not contain `serviceAccountName:` or `userAccountName:` are returned unchanged.
- `serviceAccountName:<name>` uses the `yandex_iam_service_account` data source and returns `serviceAccount:<id>`.
- `userAccountName:<login>` uses the `yandex_iam_user` data source and returns `userAccount:<id>`.
- The output preserves the input order within these groups: unchanged members first, resolved service accounts second, resolved users third.
- The module does not deduplicate values.
