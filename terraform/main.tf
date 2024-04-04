terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.45.0"
    }
  }
}

provider "hcloud" {
}

# Create a new SSH key
resource "hcloud_ssh_key" "default" {
  name       = "key-of-bryan"
  public_key = file("~/.ssh/id_ed25519_sk.pub")
}

# Create a new server running debian
resource "hcloud_server" "default" {
  name        = "node1"
  image       = "debian-11"
  server_type = "cax11"
  ssh_keys    = [hcloud_ssh_key.default.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
