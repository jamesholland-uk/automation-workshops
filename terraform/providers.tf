terraform {
    required_providers {
        panos = {
            source  = "paloaltonetworks/panos"
            version = "~> 1.8.3"
        }
    }
}

provider "panos" {
    hostname = var.panos_hostname
    username = var.panos_username
    password = var.panos_password
}
