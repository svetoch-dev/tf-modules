locals {
  gcp_dns_zones = {
    "${var.env.cloud.id}" = {
      zone = {
        name     = "${var.env.cloud.id}"
        dns_name = var.env.dns.domain
      }
      #Records are created using external-dns
      #controller in k8s
      records = [
      ]
    }
  }
}
