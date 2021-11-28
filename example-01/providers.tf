terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.67.0"
    }
  }

  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "terraformstate-burunov"
    region                      = "ru-central1-b"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }

}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}