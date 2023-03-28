variable "chart_version" {
  type        = string
  default     = "1.19.4"
  description = "version of the chart to be installed"
}

variable "namespace" {
  type        = string
  default     = "coredns-external-resolver"
  description = "namespace into which grafana should be installed"
}

variable "service_name" {
  type        = string
  default     = "coredns-external-resolver"
  description = "name of the kubernetes service"
}

variable "service_type" {
  type        = string
  default     = "LoadBalancer"
  description = "Kubernetes Service type"
  validation {
    condition = contains(
      ["LoadBalancer", "ClusterIP", "NodePort"],
      var.service_type
    )
    error_message = "Error: service_type value is not valid."
  }
}

variable "service_load_balancer_ip" {
  type        = string
  default     = null
  description = "fixed ip address to use if you are using service_type LoadBalancer"
}

variable "service_load_balancer_type" {
  type        = string
  default     = null
  description = "type of load balancer being used in the cluster"
}

variable "service_annotations" {
  type        = list(strings)
  default     = {}
  description = "annotations required if using kubernetes service load balancer"
}
  
variable "is_cluster_service" {
  type    = bool
  default = false
}
