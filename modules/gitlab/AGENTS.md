# GitLab modules

- Follow [repository selections and key generation](main.tf) into the [repository child](repository/main.tf). This configures deploy keys and project variables for an existing project; it does not create projects.
- Preserve the parent-built `org/name` project path and its distinction from selection keys and connection URLs derived from the configured domain.
- Generate requested deploy keys in the parent and reuse their public keys in child calls. Preserve the child's inversion from `read_only` to `can_push`.
- Keep generated/supplied key material and connection information in the sensitive [parent output](output.tf), keyed by repository selection. The child has no output contract to forward.
- Use the existing [GitLab Bazel package](BUILD.bazel): `//modules/gitlab:lint` and `//modules/gitlab:validate`.
