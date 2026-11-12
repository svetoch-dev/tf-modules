# ROD GitHub Actions CI Module

Builds GitHub Actions repository configuration for the ROD infrastructure repository and application repositories. It creates Actions variables from environment/CD metadata and passes the resulting definitions to the shared [GitHub module](../../../github/README.md).

## Usage

```hcl
module "ci" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/ci/gha?ref=<release-ref>"

  env            = local.env # CI environment using the shared ROD schema
  bazelisk_image = "europe-docker.pkg.dev/example/tools/bazelisk:latest"
  ci_image       = "europe-docker.pkg.dev/example/tools/ci-deploy:v0.1.0"

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
              update                  = true
              deletion                = true
              non_fast_forward        = true
              required_linear_history = true
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

Replace `<release-ref>` with a release or commit containing this interface. `local.env` must satisfy the full shared ROD environment schema.

`ci_image` and `bazelisk_image` are complete container image references, including their tags or digests. The caller selects the registry and resolves image versions before invoking this module; the module does not read image tag files or add a default CI image version.

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
| `env` | Shared ROD environment schema. Must be non-null to generate runner names from `cloud.name` and `short_name`. | `object` | `null` | no |
| `company` | Shared company metadata; unused by this module. | `object({ name = string, domain = string })` | `null` | no |
| `ci` | Shared CI metadata; unused by this module. | `object({ type = string })` | `null` | no |
| `int_env` | Shared internal environment metadata; unused by this module. | `any` | `null` | no |
| `ci_image` | Full CI deploy container image URL. | `string` | n/a | yes |
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
  runner_name = {
    name  = "RUNNER_NAME"
    value = "gha-runner-${var.env.cloud.name}-${var.env.short_name}"
  }
  bazelisk_image = {
    name  = "BAZELISK_IMAGE"
    value = var.bazelisk_image
  }
}
```

Each `app_env_ci_configs` item keeps its `<env.short_name>_<app_name>` entry for CD settings, registry variables, secrets, and repository overrides. A separate `repo:<org>/<repo.name>` entry manages only the shared variables: `CI_IMAGE`, `KANIKO_IMAGE`, `RUNNER_NAME`, `INFRA_REPO_URL`, and `REGISTRY`. Shared entries are deduplicated by repository identity. The infrastructure entry retains its `infrastructure` key.

Non-null values become environment-prefixed Actions variables:

| Source field | Variable name |
|-------------|---------------|
| `env.registry_url` | `<ENV>_REGISTRY_URL` |
| `cd.branch` | `<ENV>_CD_BRANCH` |
| `cd.file` | `<ENV>_CD_FILE` |
| `cd.tag_path` | `<ENV>_CD_TAG_PATH` |

For example, `env.short_name = "int"` and `app_name = "api"` produce the override key `int_api` and variable names beginning with `INT_`.

Application repositories also receive:

| Variable | Value |
|----------|-------|
| `CI_IMAGE` | The full `var.ci_image` reference, shared across application environments. |
| `REGISTRY` | Hostname from the CI environment `env.registry.url`. Override this shared variable if application builds authenticate against a different registry host. |
| `RUNNER_NAME` | `gha-runner-app-<env.cloud.name>-<env.short_name>`, using the module's CI environment. |
| `KANIKO_IMAGE` | `ghcr.io/osscontainertools/kaniko:v1.29.1-debug@sha256:ebc38a988e5aa1aaea99240e931aeeeff9d8e6bb5a0bd0e00eaf79973bf0a773`. |

For example, with CI in `gcp-int`, a `prd-v2` application receives `RUNNER_NAME = gha-runner-app-gcp-int`. Its application registry comes from `app_env_ci_configs[*].env.registry_url`, while the helper image is the caller-supplied `ci_image`. Overrides can replace generated values.

Existing environment overrides and secret instance keys are unchanged; environment entries are not merged together. Override shared variables under `overrides.cis["repo:example-org/api"].vars`, using the keys `ci_image`, `kaniko_image`, `runner_name`, `infra_repo_url`, and `registry`. Do not define the same shared GitHub variable again under environment entries. If managing repository creation, enable it in only one existing entry for each repository.

## Updating existing callers

Pass the full shared ROD environment as `env` and the full helper image URL as `ci_image`. The shared `env` input defaults to null, but runner name generation now requires a non-null value. Shared inputs are declared through the `common_input.tf` symlink. The runner prefix is fixed to `gha` in this GitHub Actions module.

Remove matching overrides for `RUNNER_NAME`, `CI_IMAGE`, `REGISTRY`, and `KANIKO_IMAGE` when the generated values match your configuration. Explicit overrides still take precedence within their entry. Keep overrides when runner scale set names differ from the generated convention. The infrastructure SSH URL is also generated as `INFRA_REPO_URL`.

If testing an intermediate implementation that used `ci_image_version`, replace it with the full `ci_image` reference. Version fallback to a caller's `image_tag.txt` belongs in the caller, as with `bazelisk_image`.

### Shared variable migration

Environment module keys (`<env>_<app>`) and existing CD/secret instance keys stay unchanged. Move only unchanged shared variable state bindings to `repo:<org>/<repo.name>` before applying, using `terraform state mv`. For example:

```sh
terraform state mv \
  'module.ci.module.github.module.repositories["int_api"].github_actions_variable.variable["ci_image"]' \
  'module.ci.module.github.module.repositories["repo:example-org/api"].github_actions_variable.variable["ci_image"]'
```

Existing `<ENV>_RUNNER_NAME` variables are replaced by shared `RUNNER_NAME`; `REGISTRY` keeps its existing unprefixed name and moves to the shared repository entry. Update runner references in workflows accordingly. Multiple legacy Terraform addresses that already manage the same shared GitHub variable require selecting one canonical state entry and removing duplicate state bindings without deleting the GitHub variable. Review the plan before applying; changing a GitHub variable name may require replacement even when its state address is moved.


## Notes

- `repo.group` configures the GitHub provider owner and is the default organization for application repositories.
- `app_env_ci_configs[*].repo.group` may override the organization value in generated output, but the provider still operates under `repo.group`; use one organization per module instance.
- Repository creation is disabled by default for both infrastructure and application repositories. Enable `repository.create` through each corresponding `overrides.cis` entry when creation is required.
- `overrides.cis` accepts the same repository structure documented by the shared [GitHub module](../../../github/README.md#type-details).
- Overrides are deep-merged with generated Actions variables, so adding rulesets, webhooks, secrets, or repository settings preserves those variables.
- The caller derives `bazelisk_image`, `ci_image`, and `app_env_ci_configs` before invoking the module.
- Secrets and private key material are stored in Terraform state. Use an encrypted backend with restricted access.
