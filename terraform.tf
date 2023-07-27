# terraform {
#   required_providers {
#     docker = {
#       source = "kreuzwerker/docker"
#       version = "~> 3.0.1"
#     }
#   }
# }

# resource "docker_network" "devopsbridge" {
#   name = "devops"
#   driver = "bridge"
# }

# resource "docker_network" "devopssecond" {
#   name = "devops_second"
#   driver = "bridge"
# }

# resource "docker_volume" "first_shared_volume" {
#   name = "first_shared_volume"
# }

# resource "docker_volume" "second_shared_volume" {
#   name = "second_shared_volume"
# }

# provider "docker" {}

# resource "docker_image" "nginx" {
#   name         = "nginx:latest"
#   keep_locally = false
# }

# resource "docker_container" "nginx" {
#   image = docker_image.nginx.image_id
#   name  = var.name
#   ports {
#     internal = var.internalport
#     external = 5566
#   }
#   networks_advanced {
#     name = docker_network.devopsbridge.name
#   }
#   volumes {
#     volume_name = docker_volume.first_shared_volume.name
#     container_path = "/Users/ar-esteban.pinon/Documents/ESGI/DevOp/Projet-Devops2"
#   }
# }

# resource "docker_container" "nginx2" {
#   image = docker_image.nginx.image_id
#   name  = "docker-terraform-2"
#   ports {
#     internal = var.internalport
#     external = var.externalport
#   }
#   networks_advanced {
#     name = docker_network.devopssecond.name
#   }
#   volumes {
#     volume_name = docker_volume.second_shared_volume.name
#     container_path = "/Users/ar-esteban.pinon/Documents/ESGI/DevOp/Projet-Devops2"
#   }
#   depends_on = [ docker_container.nginx ]
# }

# resource "docker_image" "myappfront" {
#   name         = "mikethemike03/projet-devops:latest"
#   keep_locally = false
# }

# resource "docker_container" "myappfront" {
#   image = docker_image.myappfront.image_id
#   name  = "docker-app-front"
#   ports {
#     internal = var.internalport
#     external = 8763
#   }
#   networks_advanced {
#     name = docker_network.devopssecond.name
#   }
#   volumes {
#     volume_name = docker_volume.second_shared_volume.name
#     container_path = "/Users/ar-esteban.pinon/Documents/ESGI/DevOp/Projet-Devops2"
#   }
#   depends_on = [ docker_container.nginx ]

#   provisioner "local-exec" {
#    when = destroy
#    command = "echo 'Destruction is successful.' >> destruction.txt"
#  }
# }



#####################################################################################################


terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }
    # grafana = {
    #   source = "grafana/grafana"
    #   version = "2.1.0"
    # }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
# provider "grafana" {
#   # Configuration options
# }

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}

resource "kubernetes_deployment" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        container {
          image = "grafana/grafana:latest"
          name = "grafana"

          port {
            container_port = 3000
          }
        }
      }
    }

    replicas = 1
  }
}


resource "kubernetes_service" "grafana" {
  metadata {
    name = "grafana"
    namespace = kubernetes_namespace.grafana.metadata[0].name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      name = "http"
      port = 70
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
