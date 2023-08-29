terraform {

    required_providers {
        cloudflare = {
            source  = "cloudflare/cloudflare"
            version = "4.13.0"
        }
        http = {
            source  = "hashicorp/http"
            version = "3.4.0"
        }
        sops = {
            source  = "carlpett/sops"
            version = "0.7.2"
        }
    }
}

data "sops_file" "cloudflare_secrets" {
    source_file = "secret.sops.yaml"
}

data "cloudflare_zones" "domain" {
    filter {
        name = data.sops_file.cloudflare_secrets.data["cloudflare_domain"]
    }
}

provider "cloudflare" {
    email   = data.sops_file.cloudflare_secrets.data["cloudflare_email"]
    api_key = data.sops_file.cloudflare_secrets.data["cloudflare_apikey"]
}
