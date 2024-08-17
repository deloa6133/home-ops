terraform {

    required_providers {
        github = {
            source  = "integrations/github"
            version = "6.2.3"
        }
        http = {
            source  = "hashicorp/http"
            version = "3.4.4"
        }
        sops = {
            source  = "carlpett/sops"
            version = "1.1.1"
        }
    }
}

data "sops_file" "github_secrets" {
    source_file = "secret.sops.yaml"
}

provider "github" {
    alias = "beelze-bot"
    app_auth {
        id = data.sops_file.github_secrets.data["beelze-bot.id"]
        installation_id = data.sops_file.github_secrets.data["beelze-bot.installation_id"]
        pem_file = data.sops_file.github_secrets.data["beelze-bot.pem_file"]
    }
}

provider "github" {
    alias = "token"
    token = data.sops_file.github_secrets.data["github.token"]
}
