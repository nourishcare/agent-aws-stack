variable "stack_version" {
  type = string
}

variable "agent_version" {
  type = string
}

variable "toolbox_version" {
  type = string
}

variable "hash" {
  type = string
}

variable "ami_prefix" {
  type = string
}

variable "arch" {
  type = string
}

variable "region" {
  type    = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "install_erlang" {
  type    = string
  default = "true"
}

variable "install_ruby" {
  type    = string
  default = "false"
}

variable "install_postgis" {
  type    = string
  default = "false"
}

variable "install_redis" {
  type    = string
  default = "false"
}

variable "install_node" {
  type    = string
  default = "false"
}

variable "ruby_version" {
  type    = string
  default = "3.3.7"
}

variable "postgis_major_version" {
  type    = string
  default = "3"
}
variable "postgres_major_version" {
  type    = string
  default = "16"
}

variable "node_major_version" {
  type    = string
  default = "20"
}

variable "systemd_restart_seconds" {
  type    = string
  default = "1800"
}

packer {
  required_plugins {
    amazon = {
      version = "1.3.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${var.stack_version}-ubuntu-focal-${var.arch}-${var.hash}"
  region        = "${var.region}"
  instance_type = "${var.instance_type}"
  ssh_username  = "ubuntu"

  tags = {
    Name = "Semaphore agent"
    Version = "${var.stack_version}"
    Agent_Version = "${var.agent_version}"
    Toolbox_Version = "${var.toolbox_version}"
    Hash = "${var.hash}"
  }

  source_ami_filter {
    most_recent = true

    // Canonical's ownerId: https://ubuntu.com/server/docs/cloud-images/amazon-ec2
    owners = ["099720109477"]

    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-*"
      architecture        = "${var.arch}"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
  }
}

build {
  name = "semaphore-agent-ubuntu-focal"

  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file = "ansible/ubuntu-focal.yml"
    user          = "ubuntu"
    use_proxy     = false
    extra_arguments = [
      "--skip-tags",
      "reboot",
      "-e agent_version=${var.agent_version}",
      "-e toolbox_version=${var.toolbox_version}",
      "-e install_erlang=${var.install_erlang}",
      "-e install_ruby=${var.install_ruby}",
      "-e install_postgis=${var.install_postgis}",
      "-e install_redis=${var.install_redis}",
      "-e install_node=${var.install_node}",
      "-e ruby_version=${var.ruby_version}",
      "-e postgres_major_version=${var.postgres_major_version}",
      "-e postgis_major_version=${var.postgis_major_version}",
      "-e node_major_version=${var.node_major_version}",
      "-e systemd_restart_seconds=${var.systemd_restart_seconds}",
    ]
  }
}
