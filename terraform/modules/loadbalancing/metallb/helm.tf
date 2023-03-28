resource "helm_release" "metallb" {
  name       = "metallb"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"
  version    = var.chart_version

  values = [
    var.configuration
  ]
}
