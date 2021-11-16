terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.0"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.1.250:8006/api2/json"
    pm_password = "****"
    pm_user = "userapi@pam"
    pm_otp = ""
}

# Prepare cloud-init custom user config
data "template_file" "cicustom" {
  template  = "${file("${path.module}/templates/cicustom-user.j2")}"

  vars = {
    ssh_key = file("~/.ssh/id_rsa.pub")
    user = "osadmin"
  }
}
resource "local_file" "cicustom" {
  content   = data.template_file.cicustom.rendered
  filename  = "${path.module}/files/cicustom-user.yml"
}

# Transfer the cloud-init custom config to the Proxmox Host
resource "null_resource" "cicustom" {
  connection {
    type    = "ssh"
    user    = "root"
    private_key = file("~/.ssh/id_rsa")
    host    = "192.168.1.250"
  }

  provisioner "file" {
    source       = local_file.cicustom.filename
    destination  = "/var/lib/vz/snippets/cicustom-user.yml"
  }
}


resource "proxmox_vm_qemu" "machine01" {
    name = "machine01"
    desc = "Test server"

    target_node = "proxmox"
    pool = "Lab"

    clone = "almalinux-8-cloudinit-template"

    cores = 2
    sockets = 2
    memory = 2048
    onboot = true

    nameserver = "192.168.1.2"
    ipconfig0 = "ip=192.168.1.221/24,gw=192.168.1.1"
    cicustom = "user=local:snippets/cicustom-user.yml"
}
