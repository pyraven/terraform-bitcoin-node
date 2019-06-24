variable "project" {
  default = "<your_gcp_project_id>"
}

variable "region" {
  default = "us-central1"
}

variable "myip" {
  default = "<your_ip_here>"
}

variable "bitcoin_install" {
  description = "Path to bitcoin daemon install script within repository"
  default     = "scripts/install.sh"
}

variable "username" {
  default = "<gcp_username>"
}
