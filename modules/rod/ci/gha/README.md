# ROD GitHub Actions CI Module

Builds GitHub Actions repository configuration for the ROD infrastructure repository and application repositories. It creates Actions variables from environment/CD metadata and passes the resulting definitions to the shared [GitHub module](../../../github/README.md).

## Usage

```hcl
module "ci" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/ci/gha?ref=rod-v0.23.0"

  bazelisk_image = "europe-docker.pkg.dev/example/tools/bazelisk:latest"

  repo = {
    name  = "infrastructure"
    type  = "github"
    group = "example-org"
  }

  app_env_ci_configs = [
    {
      app_name = "api"
      env = {
        short_name   = "int"
        registry_url = "europe-docker.pkg.dev/example/apps"
      }
      repo = {
        name = "api"
      }
      cd = {
        branch   = "main"
        file     = "environments/internal/apps.yaml"
        tag_path = "images.api.tag"
      }
    }
  ]

  overrides = {
    cis = {
      infrastructure = {
        repository = {
          create     = true
          visibility = "private"
        }
      }

      int_api = {
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

        secrets = {
          registry_token = {
            name       = "INT_REGISTRY_TOKEN"
            text_value = var.registry_token
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
| `bazelisk_image` | Bazelisk container image written to the infrastructure repository as `BAZELISK_IMAGE`. | `string` | n/a | yes |
| `repo` | Infrastructure repository identity and default GitHub organization. | `object({ name = string, type = string, group = string })` | n/a | yes |
| `app_env_ci_configs` | Application/environment combinations used to build repository Actions variables. | `list(object)` | n/a | yes |
| `overrides` | Values deep-merged into generated CI repository definitions under `overrides.cis`. | `object({ cis = optional(any) })` | `{ cis = null }` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cis` | Repository URLs, organizations, and deploy key material for generated CI entries. This output is sensitive. |

## Generated Configuration

The infrastructure repository receives:

```hcl
vars = {
  bazelisk_image = {
    name  = "BAZELISK_IMAGE"
    value = var.bazelisk_image
  }
}
```

Each `app_env_ci_configs` item creates an entry keyed by `<env.short_name>_<app_name>`. Non-null values become Actions variables:

| Source field | Variable name |
|-------------|---------------|
| `env.registry_url` | `<ENV>_REGISTRY_URL` |
| `cd.branch` | `<ENV>_CD_BRANCH` |
| `cd.file` | `<ENV>_CD_FILE` |
| `cd.tag_path` | `<ENV>_CD_TAG_PATH` |

For example, `env.short_name = "int"` and `app_name = "api"` produce the override key `int_api` and variable names beginning with `INT_`.

## Notes

- `repo.group` configures the GitHub provider owner and is the default organization for application repositories.
- `app_env_ci_configs[*].repo.group` may override the organization value in generated output, but the provider still operates under `repo.group`; use one organization per module instance.
- Repository creation is disabled by default for both infrastructure and application repositories. Enable `repository.create` through each corresponding `overrides.cis` entry when creation is required.
- `overrides.cis` accepts the same repository structure documented by the shared [GitHub module](../../../github/README.md#type-details).
- Overrides are deep-merged with generated Actions variables, so adding rulesets, webhooks, secrets, or repository settings preserves those variables.
- The module has no `ci` input. The caller should derive `bazelisk_image` and `app_env_ci_configs` before invoking it.
- Secrets and private key material are stored in Terraform state. Use an encrypted backend with restricted access.
