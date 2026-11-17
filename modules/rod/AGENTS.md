# Rod compositions

- Route changes to [cloud GCP](cloud/gcp/main.tf), [cloud YC](cloud/yc/main.tf), [Kubernetes](k8s/main.tf), [GitHub](repos/github/main.tf), [GitLab](repos/gitlab/main.tf), [GitHub CI](ci/gha/main.tf), [GitLab CI](ci/gl/main.tf), or [secrets](secrets/main.tf).
- Find defaults in the affected composition's locals, then trace `overrides.tf` into its downstream call. Keep defaults first in `provider::deepmerge::mergo`; preserve the additive, deduplicated [GCP API list](cloud/gcp/overrides.tf).
- Cloud `internal` and `product` wrappers pass merged overrides to their shared Rod cloud module, which merges again. Check the affected wrapper and shared layer together.
- Preserve downstream normalization in [GCP outputs](cloud/gcp/output.tf) and [YC outputs](cloud/yc/output.tf), including cluster endpoint/certificate and network shapes consumed by Kubernetes, CI, and secrets.
- Use the affected composition's Bazel package, such as [cloud GCP](cloud/gcp/BUILD.bazel): `//modules/rod/cloud/gcp:lint` and `//modules/rod/cloud/gcp:validate`.
