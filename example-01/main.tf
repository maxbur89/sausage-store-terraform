resource "yandex_compute_instance" "vm-burunov-m" {
  name                      = "terraform-burunov-m"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.size
    }
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-terraform-burunov-m-1.id
    nat       = true
  }
}

resource "yandex_vpc_network" "network-terraform-burunov-m-1" {
  name = "network-terraform-burunov-m-1"
}

resource "yandex_vpc_subnet" "subnet-terraform-burunov-m-1" {
  name           = "subnet-terraform-burunov-m-1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-terraform-burunov-m-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_mdb_postgresql_cluster" "burunov-pg" {
  name        = "burunov-pg"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.burunov-subnet-pg.id

  config {
    version = 13
    resources {
      resource_preset_id = "b2.nano"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
    postgresql_config = {
      max_connections                   = 70
      enable_parallel_hash              = true
      vacuum_cleanup_index_scale_factor = 0.2
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  database {
    name  = "sausage"
    owner = "sausage"
  }

  user {
    name       = "sausage"
    password   = "your_password"
    conn_limit = 50
    permission {
      database_name = "sausage"
    }
    settings = {
      default_transaction_isolation = "read committed"
      log_min_duration_statement    = 5000
    }
  }

  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.burunov-subnet-pg.id
    assign_public_ip = true
  }
}

resource "yandex_vpc_network" "burunov-subnet-pg" {}

resource "yandex_vpc_subnet" "burunov-subnet-pg" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.burunov-subnet-pg.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}



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