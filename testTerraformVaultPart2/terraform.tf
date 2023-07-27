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

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx2" {
  image = docker_image.nginx.image_id
  name  = "docker-terraform-nginx"
  ports {
    internal = 80
    external = 8765
  }
  provisioner "local-exec" {
   when = create
   command = "curl http://localhost:8765 > nginx_index_content.txt"
 }
}