resource "helm_release" "minio-operator" {
  name       = "minio-operator"
  namespace  = kubernetes_namespace.minio_system.metadata[0].name
  repository = "https://operator.min.io/"
  chart      = "minio-operator"
  version    = "4.0.1"

  #values = [
  #  "${file("values.yaml")}"
  #]

  depends_on = [kubernetes_namespace.minio_system]
}
