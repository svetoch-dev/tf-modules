# Cloud Run Job module

Creates a Google Cloud Run v2 Job with one or more containers, optional VPC
access, secret volumes, and startup probes.

## Usage

```hcl
module "cloudrun_job" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/cloudrun_job?ref=master"

  name           = "example-job"
  project_id     = var.project_id
  location       = "europe-west1"
  service_account = google_service_account.worker.email

  containers = {
    worker = {
      image   = "europe-west1-docker.pkg.dev/example/app/worker:latest"
      command = ["/app/worker"]
      args    = ["--run-once"]
      resources = {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }
}
```

## Startup health check

Cloud Run Jobs support an optional startup probe. Liveness and readiness probes
are not used for Jobs; task success is determined by the container exit code.

### HTTP startup probe

```hcl
containers = {
  worker = {
    image = "europe-west1-docker.pkg.dev/example/app/worker:latest"
    ports = [{ container_port = 8080 }]

    startup_probe = {
      http_get = {
        path = "/ready"
        port = 8080
      }
      initial_delay_seconds = 5
      timeout_seconds       = 3
      period_seconds        = 5
      failure_threshold     = 12
    }

    resources = {
      limits = {
        cpu    = "1"
        memory = "512Mi"
      }
    }
  }
}
```

### TCP and gRPC startup probes

```hcl
containers = {
  worker = {
    image = "europe-west1-docker.pkg.dev/example/app/worker:latest"
    ports = [{ container_port = 9090 }]

    startup_probe = {
      grpc = {
        port    = 9090
        service = "example.Worker"
      }
    }

    resources = {
      limits = {
        cpu    = "1"
        memory = "512Mi"
      }
    }
  }
}
```

Configure only one probe type (`http_get`, `tcp_socket`, or `grpc`) per
`startup_probe`. Probe ports are optional and default to the container port.

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
| `name` | Cloud Run Job name. | n/a | yes |
| `project_id` | Google Cloud project ID. | n/a | yes |
| `location` | Cloud Run region. | n/a | yes |
| `service_account` | Service account used by the Job. | n/a | yes |
| `containers` | Container definitions and optional startup probes. | n/a | yes |
| `labels` | Labels applied to the Job. | n/a | yes |
| `parallelism` | Number of tasks run in parallel. | `1` | no |
| `timeout` | Maximum task execution time. | `null` | no |
| `max_retries` | Maximum retries for failed tasks. | `3` | no |
| `execution_environment` | Cloud Run execution environment. | `EXECUTION_ENVIRONMENT_GEN2` | no |
| `vpc_access` | Optional VPC connector and egress settings. | `null` | no |
| `volumes` | Secret volumes mounted by containers. | `{}` | no |

## Type details

### `containers`

`containers` is a map. The map key is used only to identify the container in
the input; each value has the following fields:

| Field | Type | Default | Required |
|-------|------|---------|:--------:|
| `image` | `string` | n/a | yes |
| `command` | `list(string)` | `null` | no |
| `args` | `list(string)` | `null` | no |
| `startup_probe` | `object` | `null` | no |
| `volume_mounts` | `map(object)` | `{}` | no |
| `ports` | `list(object)` | `[]` | no |
| `env` | `list(object)` | `[]` | no |
| `resources` | `object` | n/a | yes |

### Container ports and environment

Each `ports` entry contains:

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Optional protocol name. |
| `container_port` | `number` | Port listened to by the container. |

Each `env` entry contains `name`, optional literal `value`, or an optional
`secret_key_ref` with `secret` and `version`:

```hcl
env = [
  {
    name = "INPUT_BUCKET"
    value = "example-bucket"
  },
  {
    name = "API_TOKEN"
    secret_key_ref = {
      secret  = "api-token"
      version = "latest"
    }
  }
]
```

### `startup_probe`

The probe supports `initial_delay_seconds`, `timeout_seconds`, `period_seconds`,
and `failure_threshold`, plus one of `http_get`, `tcp_socket`, or `grpc`.

- `http_get`: `path`, optional `port`, and optional `http_headers`;
- `tcp_socket`: optional `port`;
- `grpc`: optional `port` and `service`.

Each HTTP header has a required `name` and optional `value`.

### `resources`

| Field | Type | Description |
|-------|------|-------------|
| `limits.memory` | `string` | Memory limit, for example `512Mi`. |
| `limits.cpu` | `string` | CPU limit, for example `1`. |

### `vpc_access`

```hcl
vpc_access = {
  connector = "projects/example-project/locations/europe-west1/connectors/job"
  egress    = "PRIVATE_RANGES_ONLY"
}
```

`egress` can be `PRIVATE_RANGES_ONLY` or `ALL_TRAFFIC`.

### `volumes`

`volumes` is a map of secret volumes. Each entry contains `name` and a
`secret` object. The secret contains `secret` and `items`; each item contains
the secret `version` and mounted file `path`.

```hcl
volumes = {
  job-secrets = {
    name = "job-secrets"
    secret = {
      secret = "job-secrets"
      items = {
        version = "latest"
        path    = "config.json"
      }
    }
  }
}

containers = {
  worker = {
    # ...other fields...
    volume_mounts = {
      job-secrets = {
        name = "job-secrets"
        path = "/var/run/secrets"
      }
    }
  }
}
```
