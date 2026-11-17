# GitHub modules

- Follow [repository selections and key generation](main.tf) into the [repository child](repository/main.tf), which owns creation, rulesets, webhooks, deploy keys, Actions secrets/variables, and environment settings.
- Keep selection keys separate from repository names. The child reuses `local.repository_name` for either a newly created repository or the supplied existing repository name; preserve both paths.
- Generate requested deploy keys in the parent, preserving composite repository/key identities and reuse of their public keys in child calls.
- Preserve the sensitive [parent result map](output.tf): it assembles connection details and generated/supplied key material under selection keys. The child has no output contract to forward.
- Use the existing [GitHub Bazel package](BUILD.bazel): `//modules/github:lint` and `//modules/github:validate`.
