# Yandex Folder IAM Role Module

Creates `yandex_resourcemanager_folder_iam_member` resources for a single role and a list of members.

## Usage

```hcl
module "folder_role" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/yc/iam/role?ref=master"

  folder_id = "b1gxxxxxxxxxxxxxxx"
  role      = "editor"
  members = [
    "serviceAccount:ajexxxxxxxxxxxxxxx",
    "userAccount:user@yandex-team.ru",
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
| `folder_id` | Yandex Cloud folder ID where the IAM role will be granted. | `string` | n/a | yes |
| `role` | IAM role to assign to each member. | `string` | n/a | yes |
| `members` | Members that should receive the role. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `this` | Map of created `yandex_resourcemanager_folder_iam_member` resources keyed by member value. |

## Notes

- The module creates one `yandex_resourcemanager_folder_iam_member` resource per entry in `members`.
- `members` are deduplicated because the module uses `toset(var.members)`.
- Member values must use Yandex Cloud IAM member format such as `serviceAccount:<id>`, `userAccount:<login>`, or `group:<id>`.
