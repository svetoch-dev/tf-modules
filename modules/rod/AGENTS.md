# Rod compositions

- Find defaults in the composition's locals and trace them through `overrides.tf` to the downstream call. Keep the defaults-first argument order in `provider::deepmerge::mergo` and preserve additive handling of the [GCP API list](cloud/gcp/overrides.tf).
- For cloud changes, check both `internal` and `product` wrappers. Each passes its merged overrides to the shared Rod cloud module, which merges again before calling [GCP](cloud/gcp/main.tf) or [Yandex Cloud](cloud/yc/main.tf).
- For Bazel checks, use the affected composition's package, such as [`//modules/rod/cloud/gcp:validate`](cloud/gcp/BUILD.bazel). Review the wrapper calls separately when you change defaults used by either variant.
