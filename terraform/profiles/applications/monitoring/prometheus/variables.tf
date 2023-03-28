variable "configuration" {
#  type = map(object({
#    namespace = optional(string)
#  }))
  type = any
  default = {}
}

variable "storage_class_mapping" {
  type = any
  default = {}
}

variable "custom_namespace" {
  type = string
  default = null
}
