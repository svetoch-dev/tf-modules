# Cloud Run Service module

Creates a Google Cloud Run v2 service with optional IAM access, VPC access,
NEG, domains, secret volumes, startup probes, and liveness probes.

## Usage

```hcl
module "cloudrun_service" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/cloudrun_service?ref=master"

  name           = "example-service"
  project_id     = var.project_id
  location       = "europe-west1"
  service_account = google_service_account.app.email

  labels = {
    environment = "production"
  }

  container = {
    image = "europe-west1-docker.pkg.dev/example/app/service:latest"
    ports = [
      {
        name           = "http1"
        container_port = 8080
      }
    ]
    env = []
    resources = {
      limits = {
        cpu    = "1"
        memory = "512Mi"
      }
    }
  }

  scaling = {
    min_instance_count = 0
    max_instance_count = 10
  }
}
```

## Health checks

All health checks are optional. HTTP, TCP, and gRPC probes can be configured.

### HTTP startup and liveness probes

```hcl
container = {
  image = "europe-west1-docker.pkg.dev/example/app/service:latest"
  ports = [{ container_port = 8080 }]

  startup_probe = {
    http_get = {
      path = "/startup"
      port = 8080
      http_headers = [
        {
          name  = "X-Health-Check"
          value = "cloud-run"
        }
      ]
    }
    initial_delay_seconds = 5
    timeout_seconds       = 3
    period_seconds        = 10
    failure_threshold     = 12
  }

  liveness_probe = {
    http_get = {
      path = "/health"
      port = 8080
    }
  }

  resources = {
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
  }
}
```

### TCP and gRPC probes

```hcl
container = {
  image = "europe-west1-docker.pkg.dev/example/app/service:latest"
  ports = [{ container_port = 9090 }]

  startup_probe = {
    grpc = {
      port    = 9090
      service = "example.Health"
    }
  }

  liveness_probe = {
    tcp_socket = {
      port = 9090
    }
  }

  resources = {
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
  }
}
```

Configure only one probe type (`http_get`, `tcp_socket`, or `grpc`) per probe.
For HTTP and gRPC probes, `port` is optional and defaults to the container
port. The liveness TCP probe requires `port`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| google | 6.40.0 |
| google-beta | 6.40.0 |
| null | 3.2.3 |
| random | 3.6.3 |

## Main inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| `name` | Cloud Run service name. | n/a | yes |
| `project_id` | Google Cloud project ID. | n/a | yes |
| `location` | Cloud Run region. | n/a | yes |
| `service_account` | Service account used by the service. | n/a | yes |
| `labels` | Labels applied to the service. | n/a | yes |
| `container` | Container image, ports, environment, resources, and probes. | n/a | yes |
| `scaling` | Minimum and maximum instance counts. | n/a | yes |
| `deletion_protection` | Protect the service from Terraform deletion. | `true` | no |
| `ingress` | Cloud Run ingress policy. | `INGRESS_TRAFFIC_ALL` | no |
| `request_timeout` | Maximum request processing time. | `300s` | no |
| `max_instance_requests` | Maximum concurrent requests per instance. | `80` | no |
| `execution_environment` | Cloud Run execution environment. | `EXECUTION_ENVIRONMENT_GEN2` | no |
| `vpc_access` | Optional VPC connector and egress settings. | `null` | no |
| `volumes` | Secret volumes mounted by the container. | `{}` | no |
| `domains` | Cloud Run custom domain mappings. | `{}` | no |
| `members` | IAM members granted `roles/run.invoker`. | `["allUsers"]` | no |
| `neg_enabled` | Create a serverless network endpoint group. | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cloudrun_service` | The Cloud Run service resource and optional NEG. |

## Type details

### `container`

| Field | Type | Default | Required |
|-------|------|---------|:--------:|
| `image` | `string` | n/a | yes |
| `volume_mounts` | `map(object)` | `{}` | no |
| `ports` | `list(object)` | n/a | yes |
| `env` | `list(object)` | `[]` | no |
| `startup_probe` | `object` | `null` | no |
| `liveness_probe` | `object` | `null` | no |
| `resources` | `object` | n/a | yes |

### `container.ports`

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Optional protocol name, for example `http1` or `h2c`. |
| `container_port` | `number` | Port listened to by the container. |

### `container.env`

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Environment variable name. |
| `value` | `string` | Literal value. Optional when `secret_key_ref` is used. |
| `secret_key_ref` | `object` | Optional Secret Manager reference. |

`secret_key_ref` contains `secret` and `version`:

```hcl
env = [
  {
    name = "DATABASE_PASSWORD"
    secret_key_ref = {
      secret  = "database-password"
      version = "latest"
    }
  }
]
```

### `container.resources`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `limits.memory` | `string` | n/a | Memory limit, for example `512Mi`. |
| `limits.cpu` | `string` | n/a | CPU limit, for example `1`. |
| `cpu_idle` | `bool` | `true` | Allocate CPU only while handling requests. |
| `startup_cpu_boost` | `bool` | `false` | Boost CPU during startup. |

### Probe types

Both `startup_probe` and `liveness_probe` support these timing fields:
`initial_delay_seconds`, `timeout_seconds`, `period_seconds`, and
`failure_threshold`.

`http_get` contains `path`, optional `port`, and optional `http_headers`.
Each header contains a required `name` and optional `value`.

`tcp_socket` contains `port`. The port is required for a liveness TCP probe
and optional for a startup TCP probe.

`grpc` contains optional `port` and `service` fields.

### `scaling`

| Field | Type | Description |
|-------|------|-------------|
| `min_instance_count` | `number` | Minimum number of instances. |
| `max_instance_count` | `number` | Maximum number of instances. |

### `vpc_access`

```hcl
vpc_access = {
  connector = "projects/example-project/locations/europe-west1/connectors/app"
  egress    = "PRIVATE_RANGES_ONLY"
}
```

`egress` can be `PRIVATE_RANGES_ONLY` or `ALL_TRAFFIC`.

### `volumes`

`volumes` is a map of secret volumes. Each entry contains `name` and a
`secret` object with `secret` and `items`. Each item contains `version` and
the file `path` inside the mounted volume.

```hcl
volumes = {
  app-secrets = {
    name = "app-secrets"
    secret = {
      secret = "app-secrets"
      items = {
        version = "latest"
        path    = "config.json"
      }
    }
  }
}

container = {
  # ...other fields...
  volume_mounts = {
    app-secrets = {
      name = "app-secrets"
      path = "/var/run/secrets"
    }
  }
}
```

### `domains`

`domains` is a map where each value contains a domain mapping name:

```hcl
domains = {
  app = {
    name = "app.example.com"
  }
}
```

### `members`

`members` contains IAM member strings granted the Cloud Run invoker role.
The default is `allUsers`:

```hcl
members = [
  "serviceAccount:frontend@example-project.iam.gserviceaccount.com"
]
```
