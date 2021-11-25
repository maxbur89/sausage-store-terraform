terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.67.0"
    }
  }
}

provider "yandex" {
  token     = "AQAAAAAThAnXAATuwXAcoV4GSUZqh-UkLMreFfw"
  cloud_id  = "b1g3jddf4nv5e9okle7p"
  folder_id = "b1gk960dgke8q6mb3j64"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-burunov-m" {
  name = "terraform-burunov-m"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8db2s90v5knmg1p7dv"
    }
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  # metadata = {
  #  ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  # }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-burunov-m-1.id
    nat       = true
  }
}

resource "yandex_vpc_network" "network-burunov-m-1" {
  name = "network-burunov-m-1"
}

resource "yandex_vpc_subnet" "subnet-burunov-m-1" {
  name           = "subnet-burunov-m-1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-burunov-m-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-burunov-m.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-burunov-m.network_interface.0.nat_ip_address
}