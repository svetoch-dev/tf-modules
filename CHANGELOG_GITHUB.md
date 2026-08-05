# github-v0.4.0

Breaking changes:
* require Terraform `>= 1.8`

Features:
* optional repository creation, disabled by default with `repository.create = false`, so existing repositories do not require import
* repository rulesets with bypass actors, merge method and status-check controls, branch/tag/push targets, and webhooks management

Enhancements:
* update `github` provider `6.12.1` -> `6.13.0`
* validate that ruleset `update_allows_fetch_and_merge` is enabled only together with `update = true`
* reject `~DEFAULT_BRANCH` conditions for tag rulesets

Documentation:
* document the safe procedure for changing a module-created repository from managed to unmanaged without deleting it

Fixes:
* build repository URLs from the configured repository name instead of the repositories map key
* return generated deploy keys only when `create = true`, avoiding references to missing `tls_private_key` resources for externally supplied keys

# github-v0.3.0

Enhancements:
* try to create only none null objects
* update `github` provider `6.6.0` -> `6.12.1`


# github-v0.2.0

Enhancements:
* version providers in module itself

# github-v0.1.1

Fixes:
* attribute `deploy_keys` is `required'`
