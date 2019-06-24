resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["allow-ssh"]
  direction = "INGRESS"
  source_ranges = ["${var.myip}"]
  target_tags   = ["bitcoin"]

}

resource "google_compute_firewall" "allow-bitcoin" {
  name    = "allow-bitcoin"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8332", "8333"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bitcoin"]
}