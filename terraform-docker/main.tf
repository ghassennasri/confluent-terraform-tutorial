#taken from Instruction 
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}



resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}
#More explanation for latest as tag for image and attribute for the docker_image resource 
# https://faun.pub/understanding-terraform-latest-in-docker-image-image-id-latest-33ca1bebe66b  
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest# Download the latest nginx image
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}