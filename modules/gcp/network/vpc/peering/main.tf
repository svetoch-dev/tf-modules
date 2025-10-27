resource "google_compute_network_peering" "local_to_peer" {
  name         = var.name
  network      = var.network
  peer_network = va.peer_network
}

resource "google_compute_network_peering" "peer_to_local" {
  count        = var.create_reverse_peering ? 1 : 0
  name         = "${var.name}-reverse"
  network      = var.network
  peer_network = va.peer_network
}
