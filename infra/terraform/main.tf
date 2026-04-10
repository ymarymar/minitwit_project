terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "swarm_node" {
  count    = 3
  name     = "swarm-node-${count.index + 1}"
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-2gb"
  region   = "fra1"
  ssh_keys = [var.ssh_key_fingerprint]
  tags   = ["swarm"]
}

resource "digitalocean_droplet" "db" {
  name     = "minitwit-db"
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-2gb"
  region   = "fra1"
  ssh_keys = [var.ssh_key_fingerprint]
  tags   = ["db"]
}

resource "digitalocean_droplet" "monitoring" {
  name     = "minitwit-monitoring"
  image    = "ubuntu-24-04-x64"
  size     = "s-1vcpu-2gb"
  region   = "fra1"
  ssh_keys = [var.ssh_key_fingerprint]
  tags   = ["monitoring"]
}

data "digitalocean_volume" "volume-db" {
  name   = "volume-db"
  region = "fra1"

}

data "digitalocean_volume" "volume-monitoring" {
  name   = "volume-monitoring"
  region = "fra1"
}

resource "digitalocean_volume_attachment" "db_volume_attachment" {
  droplet_id = digitalocean_droplet.db.id
  volume_id  = data.digitalocean_volume.volume-db.id
}

resource "digitalocean_volume_attachment" "monitoring_volume_attachment" {
  droplet_id = digitalocean_droplet.monitoring.id
  volume_id  = data.digitalocean_volume.volume-monitoring.id
}

# resource "digitalocean_certificate" "minitwit" {
#   name    = "Minitwit-certificate"
#   type    = "lets_encrypt"
#   domains = ["minitwit.app", "www.minitwit.app"]
# }

resource "digitalocean_loadbalancer" "minitwit" {
  name   = "minitwit-load-balancer"
  region = "fra1"
  enable_backend_keepalive = true

  forwarding_rule {
    entry_protocol   = "https"
    entry_port       = 443
    target_protocol  = "http"
    target_port      = 80
    certificate_name = "Minitwit-certificate"
  }

  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 80
  }

  healthcheck {
    protocol = "http"
    port     = 80
    path     = "/"
  }

  droplet_ids = digitalocean_droplet.swarm_node[*].id
}