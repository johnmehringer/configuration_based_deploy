output "path" {
  value = module.configuration_based_deploy.configuration_path
}

output "files" {
  value = module.configuration_based_deploy.configuration_files
}

output "configurations" {
  value = module.configuration_based_deploy.configurations
}

output "deployment_profiles" {
  value = module.configuration_based_deploy.deployment_profiles
}

output "custom_namespaces" {
  value = module.configuration_based_deploy.custom_namespaces
}

output "storage_class_standard" {
  value = module.configuration_based_deploy.storage_class_standard
}

output "storage_class_ephemeral" {
  value = module.configuration_based_deploy.storage_class_ephemeral
}

#output "longhorn_configuration" {
#  value = module.configuration_based_deploy.longhorn_configuration
#}

#output "database_host" {
#  value = module.configuration_based_deploy.database_host
#}
