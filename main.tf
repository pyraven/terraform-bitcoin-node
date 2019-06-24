provider "google" {
  credentials = "${file("credentials/accounts.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_instance" "node" {
  name         = "bitcoin-node"
  machine_type = "custom-2-9216"
  zone         = "us-central1-a"

  tags = ["bitcoin"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      size = 300
    }
  }
  network_interface {
    network = "default"

    access_config {
    }
  }
  metadata = {
    sshKeys = "${var.username}:${tls_private_key.ssh-key.public_key_openssh}"
  }
}

resource "null_resource" "bitcoin-install" {
  connection {
    host = "${google_compute_instance.node.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "${var.username}"
    private_key = "${tls_private_key.ssh-key.private_key_pem}"
    agent = "false"
  }
  
  provisioner "file" {
    source      = "./scripts/install.sh"
    destination = "/tmp/install.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "/tmp/install.sh"
    ]
  }
  depends_on = [google_compute_instance.node]
}