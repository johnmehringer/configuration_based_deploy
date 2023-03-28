output configuration_path {
  value = var.configuration_path
}
output configuration_files {
  value = local.configuration_files
}
output configurations {
  value = local.configurations
}

output deployment_profiles {
  value = local.deployment_profiles
}

output custom_namespaces {
  value = local.custom_namespaces
}

output storage_class_ephemeral {
  value = local.storage_class_mapping.ephemeral
}

output storage_class_standard {
  value = local.storage_class_mapping.standard
}

#output longhorn_configuration {
#  value = module.storage_longhorn[local.longhorn_deployments.0].configuration
#}

#output database_host {
#  value = module.postgresql["postgresql-test.yaml"].database_host
#}
