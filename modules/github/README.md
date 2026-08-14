# GitHub Repositories Module

Manages GitHub repositories and their rulesets, webhooks, deploy keys, Actions secrets, and Actions variables. Existing repositories can be managed without importing the repository resource by leaving `repository.create` disabled.

## Usage

```hcl
provider "github" {
  owner = "example-org"
  token = var.github_token
}

module "github" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/github?ref=github-v0.4.0"

  repositories = {
    application = {
      name = "application"
      org  = "example-org"

      repository = {
        create                 = true
        description            = "Example application"
        visibility             = "private"
        allow_auto_merge       = true
        allow_merge_commit     = false
        allow_rebase_merge     = false
        allow_squash_merge     = true
        delete_branch_on_merge = true
        topics                  = ["terraform", "application"]
      }

      rulesets = {
        main = {
          name        = "Protect main"
          target      = "branch"
          enforcement = "active"

          conditions = {
            include = ["~DEFAULT_BRANCH"]
          }

          bypass_actors = [
            {
              actor_id    = 123456
              actor_type  = "Team"
              bypass_mode = "always"
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

        tags = {
          name   = "Protect tags"
          target = "tag"

          conditions = {
            include = ["refs/tags/*"]
          }

          bypass_actors = [
            {
              actor_id   = 123456
              actor_type = "Team"
            }
          ]

          rules = {
            creation = true
            update   = true
            deletion = true
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

      deploy_keys = {
        argocd = {
          name      = "argocd"
          read_only = true
          create    = true
        }
      }

      secrets = {
        registry_token = {
          name       = "REGISTRY_TOKEN"
          text_value = var.registry_token
        }
        production_api_token = {
          name        = "API_TOKEN"
          text_value  = var.production_api_token
          environment = "production"
        }
      }

      vars = {
        environment = {
          name  = "ENVIRONMENT"
          value = "production"
        }
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8 |
| github | 6.13.0 |
| tls | 4.0.6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `repositories` | Repositories and their GitHub resources. Webhook secrets and Actions secrets are stored in Terraform state. | `map(object)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `repositories` | Repository SSH/HTTP URLs, organization names, and deploy key material. This output is sensitive. |

## Notes

- Configure the GitHub provider `owner` for the organization containing the repositories. A module instance is expected to manage repositories from one organization.
- `repository.create` defaults to `false`. In that mode, the module does not manage `github_repository` and applies the configured rulesets, webhooks, deploy keys, secrets, and variables to an existing repository by name.
- Set `repository.create = true` to create and manage the repository. Repository creation defaults to private visibility.
- Do not change `repository.create` from `true` to `false` for a repository already created by this module: Terraform will plan to destroy the managed `github_repository`. To stop managing the repository without deleting it, first remove that resource from the Terraform state with `terraform state rm` and then set `create = false`.
- `webhooks[*].content_type` defaults to `"json"`; valid values are `"json"` and `"form"`. Each webhook must specify at least one event.
- Webhook secrets and Actions secrets are marked sensitive where supported, but they are still stored in Terraform state. Use an encrypted remote backend with restricted access.
- `deploy_keys[*].create = true` generates an ED25519 key pair. Otherwise, provide `public_key`; externally supplied `private_key` is returned through the sensitive output when needed by consumers.
- Ruleset status-check context names must exactly match the check names reported to GitHub.
- `rulesets[*].rules.update_allows_fetch_and_merge = true` requires `rulesets[*].rules.update = true`.
- Tag rulesets must use explicit tag patterns such as `refs/tags/*`; `~DEFAULT_BRANCH` is valid only for branch rulesets.
- `bypass_actors[*].actor_id` is the numeric actor ID expected by GitHub, not a team slug or login.

## Type Details

### `repositories`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | Repository name. |
| `org` | `string` | yes | Organization used to construct repository output URLs. It must match the configured provider owner. |
| `repository` | `object` | no | Repository creation and settings. Defaults to `{ create = false, ... }`. |
| `rulesets` | `map(object)` | no | Repository rulesets keyed by a Terraform-stable name. Defaults to `{}`. |
| `webhooks` | `map(object)` | no | Repository webhooks keyed by a Terraform-stable name. Defaults to `{}`. |
| `deploy_keys` | `map(object)` | no | Generated or externally supplied deploy keys. Defaults to `{}`. |
| `secrets` | `map(object)` | no | GitHub Actions repository secrets. Defaults to `{}`. |
| `vars` | `map(object)` | no | GitHub Actions repository variables. Defaults to `{}`. |

### `repositories{}.repository`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `create` | `bool` | `false` | Whether to create and manage the repository resource. |
| `description` | `string` | `null` | Repository description. |
| `homepage_url` | `string` | `null` | Repository homepage URL. |
| `visibility` | `string` | `"private"` | Repository visibility. |
| `archived` | `bool` | `false` | Whether the repository is archived. |
| `archive_on_destroy` | `bool` | `null` | Archive instead of deleting on destroy. |
| `auto_init` | `bool` | `null` | Create an initial commit. |
| `gitignore_template` | `string` | `null` | Gitignore template name. |
| `license_template` | `string` | `null` | License template name. |
| `is_template` | `bool` | `null` | Whether the repository is a template. |
| `topics` | `set(string)` | `null` | Repository topics. |
| `has_issues` | `bool` | `null` | Enable GitHub Issues. |
| `has_projects` | `bool` | `null` | Enable GitHub Projects. |
| `has_wiki` | `bool` | `null` | Enable the wiki. |
| `has_discussions` | `bool` | `null` | Enable GitHub Discussions. |
| `allow_auto_merge` | `bool` | `false` | Allow pull requests to be merged automatically after requirements pass. |
| `allow_merge_commit` | `bool` | `true` | Allow merge commits. |
| `allow_rebase_merge` | `bool` | `true` | Allow rebase merging. |
| `allow_squash_merge` | `bool` | `true` | Allow squash merging. |
| `merge_commit_title` | `string` | `null` | Default merge commit title behavior; applicable when merge commits are enabled. |
| `merge_commit_message` | `string` | `null` | Default merge commit message behavior; applicable when merge commits are enabled. |
| `squash_merge_commit_title` | `string` | `null` | Default squash commit title behavior; applicable when squash merging is enabled. |
| `squash_merge_commit_message` | `string` | `null` | Default squash commit message behavior; applicable when squash merging is enabled. |
| `allow_update_branch` | `bool` | `null` | Suggest updating a pull request branch when it is behind its base branch. |
| `delete_branch_on_merge` | `bool` | `false` | Delete head branches after pull requests are merged. |
| `web_commit_signoff_required` | `bool` | `null` | Require sign-off for commits made through the web interface. |

### `repositories{}.rulesets`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `name` | `string` | n/a | Ruleset display name. |
| `target` | `string` | `"branch"` | Ruleset target: `branch`, `tag`, or `push`. |
| `enforcement` | `string` | `"active"` | Ruleset enforcement mode. |
| `conditions` | `object` | `{ include = ["~DEFAULT_BRANCH"], exclude = [] }` | Ref-name conditions for branch and tag targets. Tag rulesets must override the branch-oriented default with explicit tag patterns. Not emitted for push rulesets. |
| `bypass_actors` | `list(object)` | `[]` | Apps, teams, roles, or other supported actors allowed to bypass the ruleset. |
| `rules` | `object` | n/a | Rules enforced by the ruleset. |

### `repositories{}.rulesets{}.bypass_actors`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `actor_id` | `number` | `null` | Numeric GitHub actor ID where required by the actor type. |
| `actor_type` | `string` | n/a | GitHub actor type, such as `Team`, `Integration`, `OrganizationAdmin`, or `RepositoryRole`. |
| `bypass_mode` | `string` | `"always"` | When the actor may bypass the ruleset. |

GitHub interprets `actor_id` according to `actor_type`:

| `actor_type` | Actor | `actor_id` |
|--------------|-------|------------|
| `RepositoryRole` | Maintain role | `2` |
| `RepositoryRole` | Write role | `4` |
| `RepositoryRole` | Admin role | `5` |
| `Team` | Organization team | Numeric team ID |
| `Integration` | GitHub App | Numeric GitHub App ID |
| `User` | GitHub user | Numeric user ID |
| `OrganizationAdmin` | Organization owners | Omit |
| `DeployKey` | Repository deploy keys | Omit |
| `EnterpriseOwner` | Enterprise owners | Omit |

`2`, `4`, and `5` are all fixed `RepositoryRole` IDs supported for ruleset bypass. GitHub does not define `Read` or `Triage` as bypass roles. IDs for teams, apps, and users are assigned by GitHub and must be looked up for the corresponding actor.

Role names cannot be passed directly. For example, allowing Maintain and Admin roles to bypass a ruleset requires:

```hcl
bypass_actors = [
  {
    actor_id   = 2
    actor_type = "RepositoryRole"
  },
  {
    actor_id   = 5
    actor_type = "RepositoryRole"
  },
]
```

### `repositories{}.rulesets{}.rules`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `creation` | `bool` | `null` | Restrict creation of matching refs. |
| `update` | `bool` | `null` | Restrict updates to matching refs. |
| `update_allows_fetch_and_merge` | `bool` | `null` | Allow fetch-and-merge updates where supported. Requires `update = true`. |
| `deletion` | `bool` | `null` | Restrict deletion of matching refs. |
| `non_fast_forward` | `bool` | `null` | Prevent non-fast-forward updates. |
| `required_linear_history` | `bool` | `null` | Require linear commit history. |
| `required_signatures` | `bool` | `null` | Require signed commits. |
| `pull_request` | `object` | `null` | Pull request review and allowed merge-method requirements. |
| `required_status_checks` | `object` | `null` | Required status checks and strict branch-update behavior. |

### `repositories{}.rulesets{}.rules.pull_request`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `allowed_merge_methods` | `list(string)` | `null` | Merge methods allowed for matching pull requests. Supported values are `merge`, `squash`, and `rebase`. |
| `dismiss_stale_reviews_on_push` | `bool` | `false` | Dismiss approving reviews when new commits are pushed to the pull request. |
| `require_code_owner_review` | `bool` | `false` | Require an approving review from a code owner when files with a designated code owner are changed. |
| `require_last_push_approval` | `bool` | `false` | Require approval of the most recent reviewable push by someone other than the person who pushed it. |
| `required_approving_review_count` | `number` | `0` | Number of approving reviews required before the pull request can be merged. |
| `required_review_thread_resolution` | `bool` | `false` | Require all review threads to be resolved before the pull request can be merged. |

### `repositories{}.rulesets{}.rules.required_status_checks`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `strict` | `bool` | `false` | Require the pull request branch to be up to date with its base branch before merging. |
| `do_not_enforce_on_create` | `bool` | `false` | Do not require status checks when a matching repository or branch is created. |
| `checks` | `set(object)` | n/a | Status checks that must pass. Each check requires `context` and may specify `integration_id`. |

Each `checks` object supports:

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `context` | `string` | n/a | Exact status-check context name reported to GitHub. |
| `integration_id` | `number` | `null` | Numeric GitHub App integration ID that must report the check. Omit to accept the context from any source. |

### `repositories{}.webhooks`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `url` | `string` | n/a | Webhook delivery URL. |
| `events` | `set(string)` | n/a | Non-empty set of GitHub events that trigger the webhook. |
| `active` | `bool` | `true` | Whether GitHub delivers events to the webhook. |
| `content_type` | `string` | `"json"` | Payload format: `json` or `form`. |
| `insecure_ssl` | `bool` | `false` | Disable TLS certificate verification. Keep disabled unless strictly necessary. |
| `secret` | `string` | `null` | Shared webhook signing secret. Stored in Terraform state. |

### `repositories{}.deploy_keys`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `name` | `string` | n/a | Deploy key title. |
| `public_key` | `string` | `""` | Existing OpenSSH public key used when key generation is disabled. |
| `private_key` | `string` | `""` | Existing private key returned to downstream consumers when needed. |
| `read_only` | `bool` | n/a | Whether the deploy key is read-only. |
| `create` | `bool` | `false` | Generate an ED25519 key pair when enabled. |

### `repositories{}.secrets`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | GitHub Actions secret name. |
| `text_value` | `string` | yes | Plaintext secret value. Stored in Terraform state. |
| `environment` | `string` | no | GitHub environment name. When omitted, creates a repository-level secret. |

### `repositories{}.vars`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | GitHub Actions variable name. |
| `value` | `string` | yes | GitHub Actions variable value. |
| `environment` | `string` | no | GitHub environment name. When omitted, creates a repository-level variable. |
