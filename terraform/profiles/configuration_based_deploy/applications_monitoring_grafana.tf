module "grafana" {
  for_each = {for key,profile in local.deployment_profiles :
               key => profile if profile == "grafana"
             }

  source                = "../applications/monitoring/grafana"
  configuration         = local.configurations[each.key]
  storage_class_mapping = local.storage_class_mapping
  custom_namespace      = ( lookup(local.custom_namespaces, each.key, null) != null
                            ? kubernetes_namespace.this[each.key].metadata.0.name
                            : null
                          )
}
