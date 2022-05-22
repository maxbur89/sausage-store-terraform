terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.67.0"
    }
  }

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "burunov-bucket-private"
    region   = "ru-central1-b"
    key      = "terraform.tfstate"

    # access_key = var.access_key
    # secret_key = var.secret_key
    # or
    # логин и пароль сервисного аккаунта yandex cloud
    # export AWS_ACCESS_KEY_ID=""
    # export AWS_SECRET_ACCESS_KEY=""
    # https://oauth.yandex.ru/
    # export TF_VAR_token=


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
