resource "yandex_mdb_postgresql_cluster" "burunov-pg-ha" {
  name        = "burunov-pg-ha"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.burunov-net-ha.id

  config {
    version = 13
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
  }

  maintenance_window {
    type = "ANYTIME"
  }

  database {
    name  = "sausage"
    owner = "sausage"
  }

  user {
    name     = "sausage"
    password = "your_password"
    permission {
      database_name = "sausage"
    }
  }

  user {
    name     = "read_user"
    password = "your_password"
    permission {
      database_name = "sausage"
    }
  }

  user {
    name     = "write_user"
    password = "your_password"
    permission {
      database_name = "sausage"
    }
  }

  user {
    name     = "admin_user"
    password = "your_password"
    permission {
      database_name = "sausage"
    }
  }


  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.burunov-subnet-ha-a.id
    assign_public_ip = true
  }

  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.burunov-subnet-ha-b.id
    assign_public_ip = true
  }
}

resource "yandex_vpc_network" "burunov-net-ha" {}

resource "yandex_vpc_subnet" "burunov-subnet-ha-a" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.burunov-net-ha.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "burunov-subnet-ha-b" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.burunov-net-ha.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

# MONGODB
resource "yandex_vpc_network" "burunov-network-mongodb-single" {}

resource "yandex_vpc_subnet" "burunov-subnet-mongodb-single" {
  name           = "burunov-subnet-mongodb-single"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.burunov-network-mongodb-single.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_mdb_mongodb_cluster" "burunov-mongodb-single" {
  name        = "burunov-mongodb-single"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.burunov-network-mongodb-single.id

  cluster_config {
    version = "4.4"
  }

  labels = {
    test_key = "test_value"
  }

  database {
    name = "sausage"
  }

  user {
    name     = "sausage"
    password = "your_password"
    permission {
      database_name = "sausage"
      roles         = ["readWrite", "mdbDbAdmin"]
    }
  }

  resources {
    resource_preset_id = "b1.nano"
    disk_size          = 16
    disk_type_id       = "network-hdd"
  }

  host {
    zone_id          = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.burunov-subnet-mongodb-single.id
    assign_public_ip = true
  }

  maintenance_window {
    type = "ANYTIME"
  }
}