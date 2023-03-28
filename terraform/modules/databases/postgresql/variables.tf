variable "database_name" {
  type = string
  description = "name of the initial database to create"
  default = "default"
}

variable "database_user" {
  type = string
  description = "name of the initial database user"
  default = "postgres"
}

variable "helm_name" {
  type = string
  default = "postgresql-ha"
}

variable "chart_version" {
  type = string
  default = "11.1.3"
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

variable "volume_storage_size" {
  type = string
  default = "10Gi"
}

variable "volume_storage_class" {
  type = string
  default = "default"
}

variable "passwords_secret_name" {
  type = string
  default = "postgresql-passwords"
}

variable "replica_count" {
  type = number
  default = 2
}
