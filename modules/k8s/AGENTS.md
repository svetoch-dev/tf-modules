# Kubernetes modules

- The [family module](main.tf) delegates whole collections to singleton [namespaces](namespaces/main.tf), [RBAC](rbac/main.tf), and [services](services/main.tf) children. Those children iterate resources; an empty collection does not remove the child module instance.
- Preserve namespace-before-RBAC/services dependencies when changing delegation or resource placement.
- Check resource identity in the affected child: namespace keys can differ from metadata names, while service and service-account keys include namespace context.
- [Secret](secret/main.tf) is a separately callable child, used directly by [Secrets](../secrets/main.tf), outside this family's aggregate. The aggregate and its three children have no result outputs; secret does.
- Use the existing [Kubernetes Bazel package](BUILD.bazel): `//modules/k8s:lint` and `//modules/k8s:validate`.
