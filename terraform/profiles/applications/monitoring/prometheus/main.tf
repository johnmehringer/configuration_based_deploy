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

module "prometheus" {
  source = "../../../../modules/applications/monitoring/prometheus"
  
  chart_version                    = local.configuration.chart_version
  namespace                        = local.namespace
  server_volume_size               = local.configuration.volume_size
  server_volume_storage_class      = local.volume_storage_class
  additional_scrape_configs        = local.configuration.scrape_configs 
  node_exporter_host_root_fs_mount = local.configuration.node_exporter_host_root_fs_mount
}
