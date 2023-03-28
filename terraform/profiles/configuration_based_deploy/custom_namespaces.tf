locals {
  custom_namespaces = { for key,value in local.deployment_profiles :
                          key => local.configurations[key].namespace
                          if lookup(local.configurations[key], "namespace", null) != null 
                      }
}

resource kubernetes_namespace "this" {
  for_each = local.custom_namespaces
             
  metadata {
    name = each.value
  }
}
