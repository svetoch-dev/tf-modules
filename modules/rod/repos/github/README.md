# ROD GitHub Repository Module

Builds the ROD infrastructure repository definition and manages it through the shared [GitHub module](../../../github/README.md). The generated definition includes an `argocd` ED25519 deploy key and can be extended with repository settings, rulesets, webhooks, Actions secrets, and Actions variables through `overrides.repos`.

## Usage

```hcl
module "repos" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/repos/github?ref=rod-v0.23.0"

  repo = {
    name  = "infrastructure"
    type  = "github"
    group = "example-org"
  }

  overrides = {
    repos = {
      infrastructure = {
        repository = {
          create                 = true
          visibility             = "private"
          allow_auto_merge       = true
          allow_merge_commit     = false
          allow_rebase_merge     = false
          allow_squash_merge     = true
          delete_branch_on_merge = true
        }

        rulesets = {
          main = {
            name = "Protect main"

            bypass_actors = [
              {
                actor_id   = 123456
                actor_type = "Team"
              }
            ]

            rules = {
              update                   = true
              deletion                 = true
              non_fast_forward         = true
              required_linear_history  = true
              pull_request = {
                allowed_merge_methods = ["squash"]
              }
              required_status_checks = {
                strict = true
                checks = [
                  {
                    context = "ci"
                  }
                ]
              }
            }
          }
        }

        webhooks = {
          ci = {
            url    = "https://ci.example.com/github"
            events = ["push", "pull_request"]
            secret = var.webhook_secret
          }
        }
      }
    }
  }
}
```

Authentication is read by the GitHub provider, for example from `GITHUB_TOKEN`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8 |
| deepmerge | 1.2.1 |
| github | 6.13.0 (through the shared GitHub module) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `repo` | Infrastructure repository identity and GitHub organization. | `object({ name = string, type = string, group = string })` | n/a | yes |
| `overrides` | Values deep-merged into the generated repository definitions under `overrides.repos`. | `object({ repos = optional(any) })` | `{ repos = null }` | no |

## Outputs

| Name | Description |
|------|-------------|
| `repo` | Repository URLs, organization, and deploy key material. This output is sensitive. |

## Generated Configuration

The module creates this base definition before applying overrides:

```hcl
repos = {
  infrastructure = {
    name = var.repo.name
    org  = var.repo.group
    deploy_keys = {
      argocd = {
        name      = "argocd"
        read_only = true
        create    = true
      }
    }
  }
}
```

## Notes

- The `infrastructure` map key is stable; `repo.name` controls the actual GitHub repository name.
- Repository creation is disabled by default. Set `overrides.repos.infrastructure.repository.create = true` to create it. Otherwise, rulesets, webhooks, keys, secrets, and variables are applied to an existing repository.
- `overrides.repos` accepts the same repository structure documented by the shared [GitHub module](../../../github/README.md#type-details).
- Overrides are deep-merged, so adding repository settings does not remove the generated `argocd` deploy key.
- The provider owner is set from `repo.group`; all repositories managed by this module must belong to that organization.
- Generated and supplied secrets and private keys are stored in Terraform state. Use an encrypted backend with restricted access.
