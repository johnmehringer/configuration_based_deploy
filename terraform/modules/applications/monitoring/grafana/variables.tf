variable "chart_version" {
  type = string
  default = "6.23.2"
}

variable "namespace" {
  type = string
  default = "default"
}

variable "persistence_enabled" {
  type = bool
  default = false
}

variable "volume_size" {
  type = string
  default = "10Gi"
}

variable "volume_storage_class" {
  type = string
  default = "default"
}
