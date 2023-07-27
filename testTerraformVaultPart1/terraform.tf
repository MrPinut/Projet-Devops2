terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "vault" {
  name         = "vault:1.13.3"
  keep_locally = false
}

resource "docker_container" "vault" {
  name  = "vault-container"
  image = docker_image.vault.image_id
  ports {
    internal = 8200
    external = 8200
  }
  command = ["server", "-dev"]
  env = [
    "VAULT_DEV_ROOT_TOKEN_ID=root", # Set the root token for Vault in development mode
  ]
}