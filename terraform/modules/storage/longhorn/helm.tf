resource "helm_release" "longhorn" {
  name       = "longhorn"
  namespace  = var.namespace
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = var.chart_version

  #values = [
  #  "${file("values.yaml")}"
  #]
}
