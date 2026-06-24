packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "docker" "ubuntu" {
  image  = "docker.io/ubuntu:latest"
  commit = true
  changes = [
    "ENTRYPOINT [\"/usr/bin/python3\", \"/app/azure-vote/main.py\"]",
    "EXPOSE 80"
  ]
}

build {
  name = "build-voting-app"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file   = "./ansible/playbook.yml"
    extra_arguments = ["--scp-extra-args", "'-O'"]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "buntasam/voting-app"
      tags       = ["latest"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = env("DOCKERHUB_USERNAME")
      login_password = env("DOCKERHUB_TOKEN")
    }
  }
}