# Repository Guidelines

## Purpose and architecture

- This repository is a library of reusable Terraform modules for cloud resources, Kubernetes, repositories, databases, secrets, and rod environment composition.
- Provider-level modules compose local child modules and enable resources through inputs. Environment configuration and operational state normally belong to consuming repositories.
- Build on native provider resources and local modules; do not introduce third-party Terraform modules without an explicit task requirement. Preserve existing upstream attribution and licenses.
- Keep defaults and examples reusable: no real company names, cloud IDs, credentials, or consumer-specific paths.

## Repository structure

- `modules/<domain>/`: provider or domain entry modules, including `gcp`, `k8s`, `yc`, `github`, `gitlab`, `cloudflare`, `mongodb_atlas`, `postgres`, and `secrets`.
- `modules/<domain>/<resource>/`: child modules for individual resource groups; nesting can be deeper.
- `modules/rod/`: composition and configuration for cloud, Kubernetes, repositories, CI, and secrets, including `internal` and `product` wrappers.
- Follow adjacent file names: `main.tf`, `input.tf` or `inputs.tf`, `output.tf` or `outputs.tf`, and `versions.tf`; do not rename files merely for uniformity.
- Module `README.md` files describe usage, inputs, defaults, outputs, and migration notes.
- `CHANGELOG.md` links repository releases to domain releases in `CHANGELOG_*.md`.
- `MODULE.bazel`, `BUILD.bazel`, and `tools/macros/tf.bzl`: Terraform toolchain and formatting/validation targets.
- `.github/workflows/pr.yaml`: PR checks through `bazel test //...`.
- `.pre-commit-config.yaml`: Terraform formatting hook.
- `scripts/`: development helpers; inspect effects before running them.
- `TODO.md`: milestones and checklist for the current provider upgrade.

## Task workflow

1. Inspect relevant files, branch, working tree, and existing instructions before changing code.
2. Describe the goal, affected modules, approach, checks, and material compatibility or infrastructure risks.
3. Work within the user's authorized scope without repeatedly requesting permission; agree material scope expansion before implementing it.
4. Make the smallest useful change, preserve unrelated user edits, and keep provider upgrades separate from unrelated refactoring.
5. Inspect the complete diff and run checks appropriate to the change.
6. Report changes, evidence, checks actually run, and remaining limitations. Report confirmed unrelated problems separately instead of silently fixing them.

## Module design: KISS

- Find the closest existing module and compose local building blocks before adding an abstraction.
- Preserve input/output contracts, resource names, addresses, `count`/`for_each` keys, and provider mappings unless the task requires a migration.
- Do not add unused inputs, speculative fallback logic, or duplicate provider configurations.
- Use typed inputs, descriptions, and meaningful validation; mark sensitive inputs and outputs appropriately. Sensitive values can still be stored in state.
- Document changed behavior and required consumer migrations in the affected module README and domain changelog.
- Check the Terraform version floor before introducing language features; a declared `>= 0.13` does not prove the current module works on that version.

## Providers and version policy

- Declare provider source addresses and constraints in `required_providers`, normally in `versions.tf`.
- Root entry modules pin an exact tested release, for example `version = "8.3.5"`; reusable child modules use a compatible range, for example `version = "~> 8.0"`.
- Determine root/child roles from the module call graph and intended use. The repository root contains no Terraform configuration; directory depth alone does not identify an operational root module.
- Consuming deployment roots should also pin exact versions and maintain their own dependency lock files.
- `~> 8.0` permits `>= 8.0, < 9.0`; `~> 8.0.0` permits only `8.0.x`. HCL strings use double quotes and version constraints have no trailing dot.
- Raise the child module's lower bound when it needs a feature or fix introduced after the major's initial release.
- Resolve constraints across the whole module graph. Terraform selects one version per provider source address, including aliased configurations.
- Review `google` and `google-beta` together and select compatible releases. Check both schemas where resources explicitly use `google-beta`.
- Verify latest stable versions, upgrade guides, and release notes using official Registry and provider repositories; record verification dates and links. Never treat an example version as the target release.
- Review all intervening breaking changes, defaults, state/schema migrations, and resource replacement behavior before upgrading a major version.
- `.terraform.lock.hcl` is currently ignored. Do not change this policy or force-add ignored files incidentally; decide lock ownership explicitly for real deployment roots and test fixtures.
- Do not remove a provider merely because no resource declaration uses it: inspect data sources, aliases, module requirements, and existing state first.

## Verification and CI

- `MODULE.bazel` currently pins Terraform `1.14.4`; `.bazeliskrc` pins Bazel `8.1.0`. Read the files again when working on toolchain changes.
- Check `terraform version` before local validation and explain any difference from CI. Do not silently upgrade the runtime as part of a provider-only task.
- For documentation-only changes, inspect Markdown, links, and `git diff --check`; Terraform initialization is unnecessary.
- For HCL changes, run formatting checks on affected paths, then initialize and validate each affected module graph:
  - `terraform fmt -check -recursive <affected-path>`
  - `terraform -chdir=<module-or-fixture> init -backend=false`
  - `terraform -chdir=<module-or-fixture> validate`
- Use `init -upgrade -backend=false` only when intentionally resolving upgraded dependencies, preferably in isolated fixtures.
- Run relevant Bazel targets and `bazel test //...` for broad changes. The macro provides formatting and validation with backend initialization disabled; these checks do not prove compatibility with deployed state.
- Before a commit, run `pre-commit run --files <changed-files>` when applicable. Its current hook checks formatting, not plans or infrastructure behavior.
- Test representative child modules and compositions; checking the top-level module alone does not cover every child interface.
- For upgrade verification in a real consumer, compare baseline and candidate plans with the same inputs, backend, and runtime. Save reviewed plan artifacts and explain every unexpected update, replacement, or deletion.
- Add focused tests only where they verify a concrete risk. Report missing credentials, unavailable tools, and checks that could not run.

## State and operational restrictions

- Never commit credentials, `.tfvars` containing secrets, state, plan artifacts, `.terraform/`, or sensitive provider/debug logs. Use neutral local fixtures.
- Do not run `apply`, `destroy`, imports, state mutations, backend migrations, or cloud/Kubernetes writes without authorization for that operation.
- Before any authorized destructive operation, show the full destroy plan, including dependents, and obtain confirmation for the concrete deletions.
- Provider upgrades may migrate state. Before an authorized apply, preserve backend recovery information and the previous configuration, provider pins, and lock file; confirm downgrade support rather than assuming a version revert is sufficient.
- Use the reviewed plan artifact for an authorized deployment. Do not apply directly to production without reviewing its effects.

## Git, commits, and pull requests

- Stage only task-related paths and review the staged diff before committing.
- Follow the shared repository convention for new commit subjects: `<fix|add|remove> - <short description>`.
- For meaningful module changes, update affected `CHANGELOG_*.md` files and the repository release entry consistently with the existing release scheme.
- Create commits or PRs only when requested. Do not push, amend, rebase, force-push, or discard user changes without authorization for that action.
- PR descriptions should explain the problem, solution, affected modules, consumer/state impact, migration steps, and actual validation results.
