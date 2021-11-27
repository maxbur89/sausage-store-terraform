resource "yandex_compute_instance" "vm-burunov-m" {
  name                      = "terraform-burunov-m"
  allow_stopping_for_update = true

  resources {
    cores  = 2
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
