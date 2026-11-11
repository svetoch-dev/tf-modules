locals {
  app_runner_ssh = nonsensitive(var.app_runner_private_key != null) ? {
    infrastructure_ssh = {
      name = "infrastructure-ssh"
      secrets_data = {
        known_hosts = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl\n"
        id_ed25519  = var.app_runner_private_key
      }
      k8s = {
        enabled   = true
        namespace = "gha-runner-app"
      }
      annotations = {}
      labels      = {}
    }
  } : {}
}
