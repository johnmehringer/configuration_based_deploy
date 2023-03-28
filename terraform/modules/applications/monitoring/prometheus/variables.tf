variable "chart_version" {
  type        = string
  default     = "19.7.2"
  description = "version of the chart to be installed"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "namespace into which grafana should be installed"
}

variable "rules_groups" {
  type        = list(string)
  default     = []
  description = "list of rules groups to deploy into prometheus"
}

variable "statefulset_enabled" {
  type = bool
  default = true
}

variable "server_volume_size" {
  type = string
  default = "20Gi"
}

variable "server_volume_storage_class" {
  type = string
  default = "default"
}

variable "alertmanager_enabled" {
  type = bool
  default = false
}

variable "alertmanager_volume_size" {
  type = string
  default = "1Gi"
}

variable "alertmanager_volume_storage_class" {
  type = string
  default = "default"
}

variable "additional_scrape_configs" {
  type = list(any)
  default = []
}

variable "node_exporter_host_root_fs_mount" {
  type = bool
  default = true
}
