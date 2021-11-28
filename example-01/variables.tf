variable "token" {
  description = "Token for access Yandex Cloud"
  type        = string
  default     = ""
}

variable "cloud_id" {
  description = "cloud_id for access Yandex Cloud"
  type        = string
  default     = "b1g3jddf4nv5e9okle7p"
}

variable "folder_id" {
  description = "folder_id for access Yandex Cloud"
  type        = string
  default     = "b1gk960dgke8q6mb3j64"
}

variable "zone" {
  description = "zone for access Yandex Cloud"
  type        = string
  default     = "ru-central1-b"
}

variable "access_key" {
  description = "access_key for access S3 Yandex Cloud"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "secret_key for access S3 Yandex Cloud"
  type        = string
  default     = ""
}

variable "image_id" {
  description = "image_id"
  type        = string
  default     = "fd8db2s90v5knmg1p7dv"
}

variable "size" {
  description = "disk size"
  type        = string
  default     = "10"
}