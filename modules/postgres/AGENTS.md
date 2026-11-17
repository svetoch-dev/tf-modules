# PostgreSQL modules

- Current callers select peer modules: [database inputs](database/inputs.tf) and [database/schema/extension resources](database/db.tf), or [role inputs](roles/inputs.tf) and [role/user resources](roles/main.tf). There is no family aggregate.
- The missing aggregate is unfinished implementation, not an endorsed architectural exception. Do not invent an aggregate interface or migration as part of an unrelated change; agree that work separately.
- Reuse the created database name where appropriate for schemas/extensions/grants. Preserve composite role/schema/object grant keys across the database's role files.
- In roles, reuse generated passwords for user creation and [output](roles/output.tf); the output includes only generated passwords. Check sensitivity when changing this contract.
- Checks belong to the existing [database](database/BUILD.bazel) or [roles](roles/BUILD.bazel) package, e.g. `//modules/postgres/database:lint` and `//modules/postgres/database:validate`; there is no PostgreSQL root Bazel package.
