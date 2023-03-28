resource kubernetes_namespace "minio-operator" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "minio-operator" {
  name       = "minio-operator"
  namespace  = kubernetes_namespace.minio-operator.metadata[0].name
  repository = "https://operator.min.io/"
  chart      = "operator"
  version    = var.chart_version

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             version = var.chart_version
                           }
                         ) 
           ]

  depends_on = [kubernetes_namespace.minio-operator]
}
