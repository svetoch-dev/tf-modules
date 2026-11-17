# GCP modules

- Route [aggregate inputs](input.tf) through [calls](main.tf) to the affected capability: [network](network/main.tf), [IAM](iam/main.tf), [Kubernetes](k8s/main.tf), or another selected child. [Secret](secret/main.tf) and [client configuration](client_config/main.tf) are directly callable, outside this aggregate.
- Check API activation and IAM ordering in the aggregate; direct callers must supply their own prerequisites. Reuse known project/region context and network outputs, while checking provider scope where resource arguments omit a project.
- Check actual `google`/`google-beta` resource selection and caller wiring against the affected provider declarations; requirements alone do not configure project or credentials.
- Existing external calls in [API activation](main.tf), [subnet/router/NAT wiring](network/main.tf), and [VM templates](vm/main.tf) are five departures from the native-resource rule. Replacing them requires separate migration work; do not treat them as already converted to native resources.
- The [GCP Bazel package](BUILD.bazel) provides `//modules/gcp:lint` and `//modules/gcp:validate` for leaves under this package.
