# storage is mapped based on cloud provider and storage deployments
# longhorn storage will be used if it is deployment of other storage
# TBD: figure out a way to override longhorn and use other storage classes given in the configuration
locals {
  longhorn_deployments = [ for key,value in local.deployment_profiles:
                                          key 
                                          if value == "longhorn"
                         ]
  storage_longhorn_deployed = length(local.longhorn_deployments) > 0 ? true : false
                              
  storage_class_mapping = { 
    "standard" = (
        local.cluster_configuration.cloud_provider == "r3s" && local.storage_longhorn_deployed
          ? module.storage_longhorn[local.longhorn_deployments.0].storage_class_standard

      : local.cluster_configuration.cloud_provider == "aws" && !local.storage_longhorn_deployed
          ? "gp2"

      : "local-path" # default 
    )

    "ephemeral" = (
        local.cluster_configuration.cloud_provider == "r3s" && local.storage_longhorn_deployed
          ? module.storage_longhorn[local.longhorn_deployments.0].storage_class_ephemeral

      : local.cluster_configuration.cloud_provider == "aws" && !local.storage_longhorn_deployed
          ? "gp2"
   
      : "local-path" # default 
    )
  }
}
