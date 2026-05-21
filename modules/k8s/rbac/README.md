# Kubernetes RBAC Module

Creates Kubernetes service accounts, cluster roles, cluster role bindings, roles, and role bindings.

## Usage

```hcl
module "rbac" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/k8s/rbac?ref=master"

  service_accounts = {
    application = {
      name      = "application"
      namespace = "application"
      annotations = {
        owner = "platform"
      }
    }
  }

  cluster_roles = {
    "pod-reader" = {
      rule = {
        pods = {
          api_groups = [""]
          resources  = ["pods"]
          verbs      = ["get", "list", "watch"]
        }
      }
    }
  }

  cluster_role_binding = {
    "pod-reader-application" = {
      role_ref = {
        kind = "ClusterRole"
        name = "pod-reader"
      }
      subject = {
        application = {
          kind      = "ServiceAccount"
          name      = "application"
          namespace = "application"
        }
      }
    }
  }

  roles = {
    "config-reader" = {
      namespace = "application"
      rule = {
        configmaps = {
          api_groups = [""]
          resources  = ["configmaps"]
          verbs      = ["get", "list"]
        }
      }
    }
  }

  role_binding = {
    "config-reader-application" = {
      namespace = "application"
      role_ref = {
        kind = "Role"
        name = "config-reader"
      }
      subject = {
        application = {
          kind      = "ServiceAccount"
          name      = "application"
          namespace = "application"
        }
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| kubernetes | 2.38.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `service_accounts` | Map of Kubernetes service accounts to create. | `map(object)` | `{}` | no |
| `cluster_roles` | Map of Kubernetes cluster roles to create. | `map(object)` | `{}` | no |
| `cluster_role_binding` | Map of Kubernetes cluster role bindings to create. | `map(object)` | `{}` | no |
| `roles` | Map of namespaced Kubernetes roles to create. | `map(object)` | `{}` | no |
| `role_binding` | Map of namespaced Kubernetes role bindings to create. | `map(object)` | `{}` | no |

## Notes

- Map keys are used as Kubernetes resource names for roles and bindings unless `name` is set.
- Rule and subject map keys are Terraform iteration keys and are not sent to Kubernetes.
- Service account Terraform resource keys are built from `name.namespace`.
- `role_ref.api_group` is always set to `rbac.authorization.k8s.io`.
- Cluster role bindings depend on cluster roles and service accounts created by this module.
- Role bindings depend on roles and service accounts created by this module.
- Target namespaces must already exist before applying resources that reference them.

## Type Details

### `service_accounts`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | Kubernetes service account name. |
| `namespace` | `string` | yes | Kubernetes namespace for the service account. |
| `annotations` | `map(string)` | no | Annotations assigned to the service account metadata. |
| `automount_service_account_token` | `bool` | no | Whether to automatically mount the service account token. |
| `secret` | `map(object)` | no | Secrets associated with the service account. |

### `service_accounts{}.secret`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | `string` | yes | Secret name to associate with the service account. |

### `cluster_roles`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `labels` | `map(string)` | no | Labels assigned to the cluster role metadata. |
| `annotations` | `map(string)` | no | Annotations assigned to the cluster role metadata. |
| `name` | `string` | no | Kubernetes cluster role name. Defaults to the map key. |
| `rule` | `map(object)` | no | RBAC rules for the cluster role. |

### `cluster_roles{}.rule{}`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `verbs` | `list(string)` | yes | Verbs allowed by the rule. |
| `api_groups` | `list(string)` | no | API groups matched by the rule. |
| `resources` | `list(string)` | no | Resources matched by the rule. |
| `resource_names` | `list(string)` | no | Resource names matched by the rule. |
| `non_resource_urls` | `list(string)` | no | Non-resource URLs matched by the rule. |

### `cluster_role_binding`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `labels` | `map(string)` | no | Labels assigned to the cluster role binding metadata. |
| `annotations` | `map(string)` | no | Annotations assigned to the cluster role binding metadata. |
| `name` | `string` | no | Kubernetes cluster role binding name. Defaults to the map key. |
| `role_ref` | `object` | yes | Role reference for the binding. |
| `subject` | `map(object)` | no | Subjects granted by the binding. |

### `roles`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `namespace` | `string` | yes | Kubernetes namespace for the role. |
| `labels` | `map(string)` | no | Labels assigned to the role metadata. |
| `annotations` | `map(string)` | no | Annotations assigned to the role metadata. |
| `name` | `string` | no | Kubernetes role name. Defaults to the map key. |
| `rule` | `map(object)` | no | RBAC rules for the role. |

### `roles{}.rule{}`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `verbs` | `list(string)` | yes | Verbs allowed by the rule. |
| `api_groups` | `list(string)` | no | API groups matched by the rule. |
| `resources` | `list(string)` | no | Resources matched by the rule. |
| `resource_names` | `list(string)` | no | Resource names matched by the rule. |

### `role_binding`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `namespace` | `string` | yes | Kubernetes namespace for the role binding. |
| `labels` | `map(string)` | no | Labels assigned to the role binding metadata. |
| `annotations` | `map(string)` | no | Annotations assigned to the role binding metadata. |
| `name` | `string` | no | Kubernetes role binding name. Defaults to the map key. |
| `role_ref` | `object` | yes | Role reference for the binding. |
| `subject` | `map(object)` | no | Subjects granted by the binding. |

### `role_ref`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `kind` | `string` | yes | Role reference kind, such as `Role` or `ClusterRole`. |
| `name` | `string` | yes | Referenced role name. |

### `subject{}`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `kind` | `string` | yes | Subject kind, such as `User`, `Group`, or `ServiceAccount`. |
| `name` | `string` | yes | Subject name. |
| `api_group` | `string` | no | Subject API group. |
| `namespace` | `string` | no | Subject namespace. |
