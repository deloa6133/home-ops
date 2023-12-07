terraform {
    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "bpg/proxmox"
            version = "0.40.0"
        }
        sops = {
            source = "carlpett/sops"
            version = "1.0.0"
        }
    }
}

data "sops_file" "proxmox_secrets" {
    source_file = "secret.sops.yaml"
}

provider "proxmox" {
    insecure = true
    endpoint = data.sops_file.proxmox_secrets.data["proxmox.endpoint"]
    username = data.sops_file.proxmox_secrets.data["proxmox.username"]
    password = data.sops_file.proxmox_secrets.data["proxmox.password"]
    ssh {
        agent = true
    }
}
