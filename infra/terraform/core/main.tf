# core/main.tf
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

resource "digitalocean_volume" "volume_db" {
  region                  = "fra1"
  name                    = "volume-db"
  size                    = 1
  initial_filesystem_type = "ext4"
}

resource "digitalocean_volume" "volume_monitoring" {
  region                  = "fra1"
  name                    = "volume-monitoring"
  size                    = 1
  initial_filesystem_type = "ext4"
}

resource "digitalocean_loadbalancer" "minitwit_lb" {
  name   = "minitwit"
  region = "fra1"

  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "http"
    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port                     = 80
    protocol                 = "http"
    path                     = "/"
    check_interval_seconds   = 10
    response_timeout_seconds = 5
    unhealthy_threshold      = 3
    healthy_threshold        = 5
  }

  http_idle_timeout_seconds = 60
  enable_backend_keepalive  = true
  droplet_tag               = "swarm"
}

# --- VERIFICATION OUTPUTS ---
output "core_status" {
  value = "SUCCESSFULLY PROVISIONED"
}

output "load_balancer_ip" {
  value       = digitalocean_loadbalancer.minitwit_lb.ip
  description = "The public IP address of your Load Balancer"
}

output "volume_db_id" {
  value = digitalocean_volume.volume_db.id
}