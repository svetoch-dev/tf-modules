# reCAPTCHA Enterprise Module

This module manages a Google reCAPTCHA Enterprise key. It exposes all configuration arguments and timeouts supported by `google_recaptcha_enterprise_key` in Google provider `6.40.0` and outputs the complete resource.

## Usage

```hcl
module "recaptcha" {
  source       = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/recaptcha?ref=master"
  project_id   = "my-gcp-project"
  display_name = "website-production"

  web_settings = {
    integration_type = "SCORE"
    allowed_domains  = ["example.com"]
  }

  labels = {
    env = "prod"
  }

  timeouts = {
    create = "30m"
  }
}

output "recaptcha_site_key" {
  value = module.recaptcha.this.name
}
```

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.3 |
| hashicorp/google | 6.40.0 |

## Inputs

| Name | Description | Type | Default | Required | Example |
|------|-------------|------|---------|:--------:|---------|
| `project_id` | GCP Project ID | `string` | n/a | yes | `"my-gcp-project"` |
| `display_name` | Human-readable display name of the key | `string` | n/a | yes | `"website-production"` |
| `labels` | Labels managed by this module | `map(string)` | `{}` | no | `{ env = "prod" }` |
| `android_settings` | Settings for Android apps | `object` | `null` | no | `{ allowed_package_names = ["com.example.app"] }` |
| `ios_settings` | Settings for iOS apps | `object` | `null` | no | `{ allowed_bundle_ids = ["com.example.app"] }` |
| `web_settings` | Settings for websites | `object` | `null` | no | `{ integration_type = "SCORE", allowed_domains = ["example.com"] }` |
| `testing_options` | Fixed responses for user acceptance testing | `object` | `null` | no | `{ testing_score = 0.5 }` |
| `waf_settings` | Web Application Firewall settings | `object` | `null` | no | `{ waf_feature = "CHALLENGE_PAGE", waf_service = "CA" }` |
| `timeouts` | Create, update, and delete timeouts | `object` | `{}` | no | `{ create = "30m" }` |

## Notes

- Enable the reCAPTCHA Enterprise API (`recaptchaenterprise.googleapis.com`) in the target project before using this module.
- Configure exactly one of `android_settings`, `ios_settings`, or `web_settings`. Optional settings blocks are omitted when their input is `null`.
- `waf_settings` supplements the platform settings. For example, use `web_settings` with `integration_type = "INVISIBLE"` for a WAF challenge page.
- Optional fields without explicit defaults are passed as `null`, allowing the provider to apply its defaults.
- `labels` manages only the supplied labels. The output's `effective_labels` includes labels added by other clients and services.
- The provider generates the site key (`name`) and resource identifier (`id`). These are available through the `this` output.
- Provider reference: [google_recaptcha_enterprise_key](https://registry.terraform.io/providers/hashicorp/google/6.40.0/docs/resources/recaptcha_enterprise_key).

## Type Details

### `android_settings`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `allow_all_package_names` | `bool` | no | Disables enforcement of the package allowlist when true | `false` |
| `allowed_package_names` | `list(string)` | no | Android packages allowed to use the key | `["com.example.app"]` |

### `ios_settings`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `allow_all_bundle_ids` | `bool` | no | Disables enforcement of the bundle ID allowlist when true | `false` |
| `allowed_bundle_ids` | `list(string)` | no | iOS bundle IDs allowed to use the key | `["com.example.app"]` |

### `web_settings`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `integration_type` | `string` | yes | Integration type: `SCORE`, `CHECKBOX`, or `INVISIBLE` | `"SCORE"` |
| `allow_all_domains` | `bool` | no | Disables enforcement of the domain allowlist when true | `false` |
| `allow_amp_traffic` | `bool` | no | Allows AMP websites; supported only for `SCORE` | `false` |
| `allowed_domains` | `list(string)` | no | Hosts without a scheme, path, port, query, or fragment. Subdomains are automatically allowed | `["example.com"]` |
| `challenge_security_preference` | `string` | no | Challenge difficulty for `CHECKBOX` or `INVISIBLE`: `CHALLENGE_SECURITY_PREFERENCE_UNSPECIFIED`, `USABILITY`, `BALANCE`, or `SECURITY` | `"BALANCE"` |

### `testing_options`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `testing_challenge` | `string` | no | Challenge response for `CHECKBOX` or `INVISIBLE`: `TESTING_CHALLENGE_UNSPECIFIED`, `NOCAPTCHA`, or `UNSOLVABLE_CHALLENGE` | `"NOCAPTCHA"` |
| `testing_score` | `number` | no | Fixed assessment score, between 0 and 1 inclusive | `0.5` |

### `waf_settings`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `waf_feature` | `string` | yes | WAF feature: `CHALLENGE_PAGE`, `SESSION_TOKEN`, `ACTION_TOKEN`, or `EXPRESS` | `"CHALLENGE_PAGE"` |
| `waf_service` | `string` | yes | WAF service: `CA` (Cloud Armor) or `FASTLY` | `"CA"` |

### `timeouts`

| Field | Type | Required | Description | Example |
|-------|------|:--------:|-------------|---------|
| `create` | `string` | no | Creation timeout; defaults to `"20m"` | `"30m"` |
| `update` | `string` | no | Update timeout; defaults to `"20m"` | `"30m"` |
| `delete` | `string` | no | Deletion timeout; defaults to `"20m"` | `"30m"` |

## Outputs

| Name | Description |
|------|-------------|
| `this` | Complete `google_recaptcha_enterprise_key` resource, including `name` (site key), `id`, `create_time`, `labels`, `terraform_labels`, `effective_labels`, and configured settings |
