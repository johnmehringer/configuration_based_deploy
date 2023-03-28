output "storage_class_standard" {
  value = kubernetes_storage_class.standard.metadata.0.name
}

output "storage_class_ephemeral" {
  value = kubernetes_storage_class.ephemeral.metadata.0.name
}
