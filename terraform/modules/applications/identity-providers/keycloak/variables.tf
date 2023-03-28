variable "chart_version" {
  type = string
  default = "13.3.0"
}

variable "namespace" {
  type = string
}

variable "password_version" {
  type = string
  default = "1"
}

variable "passwords_secret_name" {
  type = string
  default = "keycloak-passwords"
}

variable "admin_user" {
  type = string
  default = "keycloak_admin"
}

variable "database_host" {
  type = string
}

variable "database_port" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_password" {
  type = string
  sensitive = true
}
