variable namespace {
  type = string
}

variable container_image {
  type = string
  default = "docker.io/bitnami/openldap:2.6.4"
}

variable listen_port {
  type = number
  default = 1389
}
