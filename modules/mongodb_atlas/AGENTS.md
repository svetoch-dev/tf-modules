# MongoDB Atlas modules

- Route [aggregate selections](main.tf) to [projects](project/main.tf), [clusters](cluster/main.tf), [teams](team/main.tf), or [database users](database_user/main.tf); [outputs](output.tf) retain child maps under selection keys.
- The aggregate injects `name = each.key`, overriding an object's supplied name. Preserve that identity behavior.
- Existing leaves accept `any` and normalize attributes in `input.tf` locals before resource mapping. Read that normalization for changes; this permissive interface is not a template for new modules.
- Sibling calls do not wire project/team IDs automatically. Check explicit project IDs for clusters and users and the relevant caller's relationships.
- When touching database-user credentials or outputs, check password sensitivity through [leaf output](database_user/output.tf) and callers; the existing password output lacks an explicit sensitive marker.
- Use the existing [Atlas Bazel package](BUILD.bazel): `//modules/mongodb_atlas:lint` and `//modules/mongodb_atlas:validate`.
