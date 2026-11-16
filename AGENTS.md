# tf-modules

## Shared Rod context

Before work, read the shared [AGENTS.md](https://github.com/svetoch-dev/rod-docs/blob/docs/rep-7-context-map/docs/ai/AGENTS.md), [map.md](https://github.com/svetoch-dev/rod-docs/blob/docs/rep-7-context-map/docs/ai/map.md), and [repositories.md](https://github.com/svetoch-dev/rod-docs/blob/docs/rep-7-context-map/docs/ai/repositories.md) on the temporary `rod-docs` branch `docs/rep-7-context-map`. Verify the ref before using a local copy. Report unavailable instructions and pause work that depends on them. Read a relevant shared skill at the same ref when available.

## Purpose

This repository provides reusable Terraform modules. Provider and domain modules own resource interfaces. Rod compositions connect those modules to cloud, Kubernetes, CI, repository, and secret defaults for internal and product environments. Consuming repositories select versions, supply environment settings, and manage deployment state.

## Repository map

```text
rod / consuming repository
└─ tf-modules [you are here]
   ├─ modules/rod — compositions and environment defaults
   └─ modules/<family> — resource modules and provider or domain compositions
```

Start here even from a nested directory. Resolve the consumer's module ref, then load only the instructions for affected modules, from parent to child. Include callers when changing an interface.

| Task | Context to load |
|---|---|
| Rod defaults or overrides | [Rod compositions](modules/rod/AGENTS.md) |
| GCP resources or provider wiring | [GCP](modules/gcp/AGENTS.md) |
| Yandex Cloud resources or IAM | [YC](modules/yc/AGENTS.md) |
| Secrets import or delivery | [Secrets](modules/secrets/AGENTS.md) |
| Kubernetes resources | [`modules/k8s`](modules/k8s/): namespaces, RBAC, services, and the secret child module. |
| Other provider or data service | [`cloudflare`](modules/cloudflare/), [`github`](modules/github/), [`gitlab`](modules/gitlab/), [`mongodb_atlas`](modules/mongodb_atlas/), or [`postgres`](modules/postgres/). Follow the caller's exact `source`. |

## Local rules

- Read the affected module's inputs, implementation, outputs, `versions.tf`, and README where present. Preserve input and output contracts, defaults, resource and module addresses, and `for_each` keys. Agree on migration requirements for intentional breaking changes.
- Trace the consumer's `terraform.tfvars` or `terraform.tfvars.json` wiring. In Rod Bazel consumers, `MODULE.bazel` loads the repository's `terraform.tfvars.json` via `load_file.json` and passes it to `bazel-lib` via `override_repo`. The Terraform root's `BUILD.bazel` calls the pinned `tf()` macro to generate `main.tf`, `tf_variables.tf`, and the root's `terraform.tfvars.json`. Follow declarations for shared and environment inputs, including backend settings. Keep values in the consumer.
- Trace changes through callers. When a consumer uses an application wrapper, follow its `*-app_variables.tf` declarations through the environment root and local wrapper to the pinned shared modules. Check the wrapper interface alongside the shared module. Keep product details in the consuming repository.
- Check Terraform and provider constraints across the affected module graph, including aliases passed by callers. The CI toolchain in [`MODULE.bazel`](MODULE.bazel) is separate from declared module support. **TODO:** Agree on the supported Terraform minimum outside Bazel and how to declare constraints across module layers.
- Keep credentials, state, plan contents, and values of sensitive outputs out of source, logs, and AI context. Trace dependencies using declarations and follow shared environment rules for plans, state access, and deployment.
- For a provider update, follow the existing entries in the affected `CHANGELOG_<FAMILY>.md` and record the version change there. When preparing a release, choose the next tag from the version sequence in the relevant changelog. Link family releases from [`CHANGELOG.md`](CHANGELOG.md) as in existing entries.

## Checks

- The [local hook](.pre-commit-config.yaml) runs `terraform_fmt`; [setup](README.md#prerequisites) is in the root README. Inspect formatting changes before staging.
- Run `bazel test //<package>:lint //<package>:validate` for affected packages using [`tf_test`](tools/macros/tf.bzl). `:lint` checks Terraform formatting. `:validate` initializes without a backend and can still download providers or modules. [PR CI](.github/workflows/pr.yaml) runs `bazel test //...`.
