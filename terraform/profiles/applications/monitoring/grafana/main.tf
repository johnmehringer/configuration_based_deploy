locals {
  configuration = merge(yamldecode(file("${path.module}/configuration.yaml")),
                        var.configuration
                       )
  namespace = (var.custom_namespace == null 
                ? kubernetes_namespace.this.0.metadata.0.name
                : var.custom_namespace
              )

  volume_storage_class = var.storage_class_mapping[local.configuration.volume_storage_class]
}

module "grafana" {
  source = "../../../../modules/applications/monitoring/grafana"

  namespace            = local.namespace
  chart_version        = local.configuration.chart_version
  persistence_enabled  = local.configuration.persistence_enabled
  volume_storage_class = local.volume_storage_class
}
