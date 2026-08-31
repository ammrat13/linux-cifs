variable "vm_username" {
  type = string
}
variable "vm_password" {
  type = string
  sensitive = true
}
variable "vm_hostname_prefix" {
  type = string
}

variable "host_address" {
  type = string
}
variable "server_address" {
  type = string
}
variable "client_address" {
  type = string
}

variable "vm_interface" {
  type = string
}
variable "vm_rdma_type" {
  type = string
}

variable "server_share" {
  type = string
}

variable "vm_kernel_deb" {
  type = string
}
variable "vm_qcow" {
  type = string
}

packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  ansible-playbook = "${abspath(path.root)}/ansible/playbook.yml"
  ansible-user = var.vm_username

  ansible-common-extra-arguments = [
    # Workaround: https://bugs.launchpad.net/ubuntu/+source/rust-sudo-rs/+bug/2122414
    "-e", "ansible_become_exe=sudo.ws",
    "-e", "ansible_become_password=${var.vm_password}",

    "-e", "vm_kernel_deb=${abspath(var.vm_kernel_deb)}",

    "-e", "vm_hostname_prefix=${var.vm_hostname_prefix}",
    "-e", "vm_interface=${var.vm_interface}",
    "-e", "vm_rdma_type=${var.vm_rdma_type}",

    "-e", "host_address=${var.host_address}",
    "-e", "server_address=${var.server_address}",
    "-e", "client_address=${var.client_address}",

    "-e", "server_share=${var.server_share}",
  ]
}

source "qemu" "linux-cifs" {
  iso_url = "https://releases.ubuntu.com/26.04.1/ubuntu-26.04.1-live-server-amd64.iso"
  iso_checksum = "sha256:cc8a95cde20f6ced61a322420de00f10cc3c90ced545daa46cb9c1a117f1d927"
  output_directory = abspath(var.vm_qcow)
  headless = true

  disk_size = "50G"
  cores = 2
  memory = 4096

  # Steps copied from GRUB
  boot_wait = "2s"
  boot_steps = [
    ["c<wait>", "Open GRUB command line"],
    ["linux /casper/vmlinuz autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ---<enter><wait5>", "Set kernel and command-line arguments"],
    ["initrd /casper/initrd<enter><wait10>", "Set initial RAM disk"],
    ["boot<enter>", "Boot the installer"]
  ]

  http_content = {
    "/meta-data" = ""
    "/user-data" = templatefile("${abspath(path.root)}/autoinstall/user-data.pkrtpl.hcl", {
      vm_username = var.vm_username
      vm_password_hash = bcrypt(var.vm_password)
    })
  }

  ssh_username = var.vm_username
  ssh_password = var.vm_password
  ssh_timeout = "15m"

  shutdown_command = "echo '${var.vm_password}' | sudo -S shutdown -P now"
}

build {
  name = "linux-cifs-server"
  source "source.qemu.linux-cifs" {
    vm_name = "linux-cifs-server.qcow2"
  }

  provisioner "ansible" {
    playbook_file = local.ansible-playbook
    user = local.ansible-user
    extra_arguments = concat(local.ansible-common-extra-arguments, [
      "-e", "vm_role=server",
      "-e", "vm_address=${var.server_address}",
    ])
  }
}

build {
  name = "linux-cifs-client"
  source "source.qemu.linux-cifs" {
    vm_name = "linux-cifs-client.qcow2"
  }

  provisioner "ansible" {
    playbook_file = local.ansible-playbook
    user = local.ansible-user
    extra_arguments = concat(local.ansible-common-extra-arguments, [
      "-e", "vm_role=client",
      "-e", "vm_address=${var.client_address}",
    ])
  }
}
