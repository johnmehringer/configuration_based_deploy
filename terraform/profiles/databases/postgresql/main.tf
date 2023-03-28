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

module "this" {
  source = "../../../modules/databases/postgresql"

  database_name        = local.configuration.database_name
  database_user        = local.configuration.database_user
  helm_name            = local.configuration.helm_name
  namespace            = local.namespace
  chart_version        = local.configuration.chart_version
  volume_storage_class = local.volume_storage_class
  volume_storage_size  = local.configuration.volume_storage_size
}
