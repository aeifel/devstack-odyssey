terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.25.0"
    }
  }
}

provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id = true
  endpoints {
    ec2 = "http://localhost:4566"
  }
}

resource "aws_instance" "demo" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "localstack-demo"
  }
}

output "instance_id" {
  value = aws_instance.demo.id
}



provider "docker" {}

resource "docker_image" "redis_image" {
  name = "redis:7"
}

resource "docker_container" "redis_container" {
  name  = "redis-local"
  image = docker_image.redis_image.name
  ports {
    internal = 6379
    external = 6379
  }
}

resource "docker_image" "mongo_image" {
  name = "mongo:6"
}

resource "docker_container" "mongo_container" {
  name  = "mongo-local"
  image = docker_image.mongo_image.name
  ports {
    internal = 27017
    external = 27017
  }
}
