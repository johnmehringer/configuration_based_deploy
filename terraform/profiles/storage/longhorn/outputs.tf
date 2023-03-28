output "storage_class_standard" {
#  value = module.longhorn.storage_class_standard
   value = "longhorn-storage_class_standard"
}

output "storage_class_ephemeral" {
#  value = module.longhorn.storage_class_ephemeral
  value = "longhorn-storage_class_ephemeral"
}

output "configuration" {
  value = var.configuration
}
