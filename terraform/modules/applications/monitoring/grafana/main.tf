resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts/"
  version    = var.chart_version
  namespace  = var.namespace

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             persistence_enabled  = var.persistence_enabled
                             volume_size          = var.volume_size
                             volume_storage_class = var.volume_storage_class
                           }
                         ) 
           ]
}
