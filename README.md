# tf-modules
Various modules for terraform

## Structure
`modules` folder is where all modules are stored.
* modules are grouped per provider
* each provider folder is itself a module that includes child modules (gcp/network, gcp/iam). That are turned on and off based on vars passed to provdider module

## Prerequisites
Before doing anything please follow this steps
1. Install pre-commit `pip install pre-commit`
2. Clone this project
3. Run `pre-commit install` from the project dir

## GCP provider upgrade

The GCP entry and shared secrets entry select Google/Google Beta `8.7.0`, Random `3.9.1`, and Null `3.3.2`. The `rod/cloud/gcp` entry family pins its existing Google/Google Beta and Random requirements to the same releases; `internal` and `product` retain their shared version-file symlinks. Reusable GCP children use these ranges where the providers are already declared:

| Provider | Child constraint |
| --- | --- |
| Google / Google Beta | `>= 8.0.0, < 8.8.0` |
| Random | `>= 3.0.0, < 3.10.0` |
| Null | `>= 3.0.0, < 3.4.0` |

Kubernetes provider requirements remain unchanged. No new module inputs, resource types, or optional provider features are introduced.

Before upgrading a deployment root:

* Resolve the new versions with `terraform init -upgrade` and review that root's dependency lock file. This library continues to ignore generated lock files.
* Compare baseline and candidate plans with the same inputs, backend, and Terraform runtime. Review replacements, credential changes, and in-place service/database updates. Instance template changes can also replace dependent VMs.
* GCS notifications continue to accept `projects/.../topics/...` and `//pubsub.googleapis.com/projects/.../topics/...`; the module removes the API prefix before passing the topic to the provider. The provider migrates the old state representation.
* Google 8 exposes GKE logging/monitoring component collections as sets. Consumers of full resource outputs must use set operations or iteration instead of positional indexing.
* AlloyDB cluster deletion protection now defaults to true. The existing cluster `deletion_policy` does not disable this protection; deletion/replacement requires a separately reviewed change before the destructive operation.
* Preserve previous configuration, provider pins, lock file, and backend recovery information before applying. Provider upgrades can migrate state; reverting a version pin alone is not a verified rollback.

Validation used Terraform `1.14.4` (the CI toolchain), backend-disabled initialization/validation of GCP and rod graphs, and provider lower-bound checks. This does not establish support for every Terraform version allowed by existing `required_version` declarations, or prove a no-op plan against deployed state.
