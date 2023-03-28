variable chart_version {
  type = string
  default = "3.0.9"
}

variable "configuration" {
  type    = string
  default = <<EOT
configInline:
  address-pools:
    - name: generic-cluster-pool
      protocol: layer2
      addresses:
      - 192.168.1.150-192.168.1.199 
  EOT
}

variable "namespace" {
  type = string
  default = "metallb"
}
