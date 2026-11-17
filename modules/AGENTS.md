# Terraform module architecture

Read the [repository guide](../AGENTS.md) and its shared Rod context first. Then load only the affected family guide and child instructions. This file owns common module design; family guides own provider-specific wiring and limitations.

## Structure and responsibilities

```text
tf-modules/
└─ modules/ [you are here: common module guidance]
   ├─ rod/                    template defaults and environment compositions
   └─ <family>/               provider or domain aggregate
      └─ <module>/            capability and component wiring
         └─ <submodule>/      resource interface and implementation
```

The aggregate accepts shared context and selected capabilities. A capability module connects its components through one interface. A resource submodule maps its contract to native provider resources and exposes results needed by callers. These are responsibilities; actual depth varies and a module may both own resources and call children. Follow `source` declarations, including cross-family calls. Add a layer only when it owns a distinct interface or composition.

For example, [YC](yc/) selects networks, [network](yc/network/) connects VPC/routes/subnets, and [VPC](yc/network/vpc/) implements the VPC resource.

Consumers can call any suitable level directly. Use [Rod](rod/AGENTS.md) when the template's naming, defaults, environment roles, and cross-domain wiring are required; it calls general provider/domain modules. Keep product settings in the consumer, following the root guide's `terraform.tfvars[.json]` and application-wrapper paths.

The same file responsibilities apply at each level. Existing naming variants such as `inputs.tf`, `outputs.tf`, and split implementation files retain these roles.

| File | What belongs here |
|---|---|
| `input.tf` | Public inputs, types, descriptions, required values, and deliberate module defaults. |
| `main.tf` | Resource declarations, child calls, and mappings between inputs and owned values; related implementation may be split into named `.tf` files. |
| `output.tf` | Results required across the module boundary, including sensitivity and caller-facing keys. A configuration-only module may expose none. |
| `versions.tf` | Terraform and provider dependency declarations for the module. |
| `README.md` | Usage, prerequisites, and interface details where present. |
| `AGENTS.md` | Additional context needed for tasks in this scope; common rules stay here or in the shared source. |

## Authoring and changes

- Reuse suitable modules in this repository. Implement resource behavior with native `resource` and `data` types from the selected provider. Agree on any new external module dependency; existing departures are recorded in the affected family context.
- Before changing a resource mapping, check the provider's documentation for the version actually used: required arguments, defaults, computed attributes, and update behavior. Use the resource contract rather than a third-party wrapper's interface as the baseline.
- Give new inputs explicit types and descriptions. Require values needed by the resource or the agreed interface when they cannot be derived inside the module. Keep resource-specific details at the resource boundary and template defaults in Rod.
- Make optional component selection default to an empty collection. Preserve required arguments of a selected child. Follow the whole path from optional fields through parent access and child arguments to iteration; review omitted, empty, and selected cases. Reuse child collection interfaces; `dynamic` is for nested blocks, while module/resource selection uses iteration or a collection-handling child.
- Preserve provider defaults when no requirement changes them. Introduce a module or Rod default deliberately. Distinguish omission/`null` from empty collections, empty strings, zero, and `false` according to the resource contract; defaults at a child do not repair an earlier missing-field access in its caller.
- Before adding an input or lookup, find the value in existing inputs, locals, resources, or child outputs. Reuse an available value directly. Connect dependencies at the nearest level that knows both sides; retain an explicit child input when it is needed for standalone use or an independent choice.
- Expose outputs for known consumer needs, preserving input-key-to-result correspondence where applicable. Trace sensitive values through every output boundary. Check callers before narrowing or removing an existing output.
- Read inputs, implementation, outputs, dependency declarations, and usage together with the affected callers. Check provider selection and aliases. Preserve defaults, resource/module addresses, and instance keys; agree on compatibility and migration before intentional breaking changes. Use the root guide's relevant checks.
