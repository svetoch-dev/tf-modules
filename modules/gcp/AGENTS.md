# GCP modules

- Follow [aggregate inputs](input.tf) through the [module call](main.tf) to the leaf. For leaves used directly, verify their own inputs, defaults, and outputs alongside the aggregate mapping.
- Check provider requirements and resource provider selection at both layers. Trace API activation and IAM dependencies in [the aggregate](main.tf) and verify which prerequisites direct callers must supply.
- Use the [GCP Bazel package](BUILD.bazel) targets `//modules/gcp:lint` and `//modules/gcp:validate` for leaf changes under this package.
