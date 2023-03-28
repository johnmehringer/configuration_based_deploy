variable "database_name" {
  type = string
  description = "name of the initial databse to create"
}

variable "helm_name" {
  type = string
  default = "mariadb"
}

variable "chart_version" {
  type = string
  default = "9.7.0"
}

variable "namespace" {
  type = string
  default = "default"
}

variable "password_version" {
  type = string
  default = "1"
}

variable "metrics_enabled" {
  type = bool
  default = true
}

variable "volume_size" {
  type = string
  default = "10Gi"
}

variable "volume_storage_class" {
  type = string
  default = "default"
}

variable "passwords_secret_name" {
  type = string
  default = "mariadb-passwords"
}

variable "secondary_replica_count" {
  type = number
  default = 1
}
