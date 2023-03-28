locals {
  configuration = merge(yamldecode(file("${path.module}/configuration.yaml")),
                        var.configuration
                       )
  namespace = (var.custom_namespace == null 
                ? kubernetes_namespace.this.0.metadata.0.name
                : var.custom_namespace
              )
}

module "longhorn" {
  source = "../../../modules/storage/longhorn"

  chart_version = local.configuration.chart_version
  namespace     = local.namespace
}
