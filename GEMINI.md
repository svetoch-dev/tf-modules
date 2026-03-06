# tf-modules

## Rules
- Terraform modules use only root terraform resources.
- Don't use ready terraform modules.
- Every module have same structure: <module-path>/main|output|variables|versions|example.
- DRY.

## Project Overview
This repository contains a comprehensive collection of modular, reusable Terraform configurations. The modules are grouped by their respective providers (e.g., Google Cloud Platform, Cloudflare, GitHub, GitLab, Kubernetes, MongoDB Atlas, PostgreSQL, Yandex Cloud) and are designed to simplify infrastructure deployment.

A key architectural pattern of this project is that each provider directory (e.g., `modules/gcp`) acts as an orchestrating root module. It conditionally provisions a wide variety of underlying child resources (like GKE clusters, CloudSQL databases, Cloud Run services, IAM, etc.) based on the configurations passed to it via input variables.

## Key Technologies
- Terraform (>= 0.13)
- Various Terraform Providers (Google, Google Beta, Cloudflare, Github, Gitlab, Kubernetes, MongoDB Atlas, Yandex Cloud, etc.)

## Project Structure
- `modules/`: The core directory containing all Terraform configurations, organized by provider.
  - `modules/<provider>/`: A top-level module for a specific provider.
  - `modules/<provider>/<resource>/`: Specific child modules used by the provider wrapper.
- `CHANGELOG_*.md`: Dedicated changelog files for tracking updates and versions for each provider module independently.

## Usage
As an Infrastructure as Code (IaC) library, these modules are intended to be referenced as sources in other operational Terraform environments.

Example usage:
```hcl
module "gcp_infrastructure" {
  source = "git::https://<repository-url>//modules/gcp?ref=<version>"
  
  # Pass variables to enable and configure specific GCP resources
  project = {
    id = "my-gcp-project-id"
  }
  
  # ... configure gke_clusters, cloudsql_postgres, etc. ...
}
```

## Development Conventions
Code quality and formatting are strictly enforced using `pre-commit` hooks, ensuring all Terraform files adhere to a consistent style.

### Prerequisites for Contributors
Before making changes, set up the pre-commit environment:
1. Install `pre-commit` locally (e.g., `pip install pre-commit`).
2. Run `pre-commit install` from the project's root directory.

### Formatting & Validation
The project relies on `antonbabenko/pre-commit-terraform` to automatically format the code using `terraform fmt`.

To manually trigger formatting and checks across the entire codebase:
```bash
pre-commit run --all-files
```
Or, specifically for Terraform formatting:
```bash
terraform fmt -recursive
```
