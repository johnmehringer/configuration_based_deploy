# Load all of the configurations for workloads to be deployed into the cluster
locals {
  configuration_files = fileset(var.configuration_path, "*.yaml")

  configurations = { for cf in local.configuration_files :
                       cf => yamldecode(file(join("/",[var.configuration_path,cf])))
                   }

  deployment_profiles = { for key,value in local.configurations :
                            key => lookup(value, "profile", trimsuffix(key, ".yaml")) 
                            if lookup(value, "enabled", false) != false
                        }
  cluster_configuration = local.configurations["cluster_metadata.yaml"]
}
