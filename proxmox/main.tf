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

variable "ssh_key" {
  default = "ssh-rsa AAAAB3N/WcSbTl....SmTow=="
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

    ciuser = "osadmin"
    sshkeys = var.ssh_key
}
