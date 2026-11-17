# Secret composition

- Follow [assembly](main.tf) from `secrets_to_import` through [import_secret](import_secret/main.tf), and from caller-supplied `secrets_data`, to enabled [GCP](../gcp/secret/main.tf) and [Kubernetes](../k8s/secret/main.tf) destinations.
- Reuse imported or resource-derived data across destinations. Check each destination's `enabled` filter and metadata; GCP creates individual secrets, while Kubernetes receives one merged data map.
- Preserve destination identity: GCP keys use the secret name or composition-name prefix; Kubernetes child keys combine name and namespace. Trace base64 decoding separately on each path.
- Check sensitivity through [destination outputs](output.tf) and the [Rod wrapper](../rod/secrets/output.tf), preserving their sensitive declarations when changing assembly or outputs.
- The [Secrets Bazel package](BUILD.bazel) provides `//modules/secrets:lint` and `//modules/secrets:validate`, covering the composition and both destination modules.
