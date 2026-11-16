# Secret composition

- Trace `secrets_to_import` through [`import_secret`](import_secret/main.tf) and `secrets_data` through the [composition](main.tf) to the enabled [GCP](../gcp/secret/main.tf) and [Kubernetes](../k8s/secret/main.tf) destinations. Check destination keys and base64 handling on each path.
- Check sensitivity from the declarations and preserve `sensitive = true` on the [destination outputs](output.tf) and [Rod wrapper output](../rod/secrets/output.tf).
- Use the [Secrets Bazel package](BUILD.bazel) targets `//modules/secrets:lint` and `//modules/secrets:validate` to check the composition with both destination modules.
