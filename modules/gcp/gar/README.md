# Google Artifact Registry Module

Creates a `google_artifact_registry_repository` with optional repository IAM bindings for readers and writers. Supports standard, remote, and virtual Artifact Registry repositories.

## Usage

```hcl
module "gar" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/gar?ref=master"

  repository_id = "example-registry"
  location      = "europe-west1"
  description   = "Container images"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"

  readers = [
    "serviceAccount:k8s-nodes@example-project.iam.gserviceaccount.com",
  ]

  writers = [
    "serviceAccount:runner-app@example-project.iam.gserviceaccount.com",
  ]
}
```

### Remote Repository

```hcl
module "docker_hub_cache" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/gar?ref=master"

  repository_id = "docker-hub-cache"
  location      = "europe-west1"
  description   = "Docker Hub remote cache"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"

  remote_repository = {
    description = "Docker Hub"
    docker_repository = {
      public_repository = "DOCKER_HUB"
    }
  }
}
```

### Virtual Repository

```hcl
module "virtual_registry" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/gcp/gar?ref=master"

  repository_id = "virtual-registry"
  location      = "europe-west1"
  description   = "Virtual container registry"
  format        = "DOCKER"
  mode          = "VIRTUAL_REPOSITORY"

  virtual_repository = {
    upstream_repositories = {
      primary = {
        repository = "projects/example-project/locations/europe-west1/repositories/containers"
        priority   = 10
      }
      cache = {
        repository = "projects/example-project/locations/europe-west1/repositories/docker-hub-cache"
        priority   = 20
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| google | 6.40.0 |
| google-beta | 6.40.0 |
| null | 3.2.3 |
| random | 3.6.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `repository_id` | Google Artifact Registry repository name. | `string` | n/a | yes |
| `location` | Location where the repository is created. | `string` | n/a | yes |
| `description` | User-provided repository description. | `string` | `""` | no |
| `format` | Format of packages stored in the repository. | `string` | `"DOCKER"` | no |
| `mode` | Repository mode. Possible values are `STANDARD_REPOSITORY`, `VIRTUAL_REPOSITORY`, and `REMOTE_REPOSITORY`. | `string` | `"STANDARD_REPOSITORY"` | no |
| `readers` | IAM member strings granted `roles/artifactregistry.reader` on the repository. | `list(any)` | `[]` | no |
| `writers` | IAM member strings granted `roles/artifactregistry.writer` on the repository. | `list(any)` | `[]` | no |
| `virtual_repository` | Configuration specific to a virtual repository. | `object` | `null` | no |
| `remote_repository` | Configuration specific to a remote repository. | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `this` | The `google_artifact_registry_repository.registry` resource merged with the calculated `endpoint` value. |

## Notes

- `readers` are converted into a single `google_artifact_registry_repository_iam_binding` with role `roles/artifactregistry.reader` when the list is non-empty.
- `writers` are converted into a single `google_artifact_registry_repository_iam_binding` with role `roles/artifactregistry.writer` when the list is non-empty.
- `remote_repository` is used only when `mode` is set to `REMOTE_REPOSITORY`.
- `virtual_repository` is used only when `mode` is set to `VIRTUAL_REPOSITORY`.
- For virtual repositories, each `upstream_repositories` map key is used as the upstream policy ID.
- `virtual_repository.upstream_repositories[*].priority` defaults to `10` when omitted.
- For Docker remote repositories, `remote_repository.docker_repository.public_repository` defaults to `DOCKER_HUB` when omitted.
- `this.endpoint` is calculated from `location`, `repository_id`, and `format`.
- Supported endpoint formats are `DOCKER`, `MAVEN`, `NPM`, `PYTHON`, `APT`, `YUM`, `GO`, and `GENERIC`.

## Type Details

### `virtual_repository`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `upstream_repositories` | `map(object)` | yes | Map of upstream repositories to expose through the virtual repository. |

### `virtual_repository.upstream_repositories`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `repository` | `string` | no | Full resource name of the upstream Artifact Registry repository. |
| `priority` | `number` | no | Upstream priority. Defaults to `10`. |

### `remote_repository`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `description` | `string` | no | Remote repository description. Defaults to `""`. |
| `docker_repository` | `object` | no | Docker public repository configuration. |
| `apt_repository` | `object` | no | Apt public repository configuration. |
| `yum_repository` | `object` | no | Yum public repository configuration. |

### `remote_repository.docker_repository`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `public_repository` | `string` | no | Public Docker repository source. Defaults to `DOCKER_HUB`. |

### `remote_repository.apt_repository`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `repository_base` | `string` | yes | Public Apt repository base. |
| `repository_path` | `string` | yes | Public Apt repository path. |

### `remote_repository.yum_repository`

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `repository_base` | `string` | yes | Public Yum repository base. |
| `repository_path` | `string` | yes | Public Yum repository path. |
