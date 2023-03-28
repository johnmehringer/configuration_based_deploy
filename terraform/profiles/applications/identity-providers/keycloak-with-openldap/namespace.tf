resource kubernetes_namespace "this" {
  count = lookup(var.configuration, "namespace", null) == null ? 1 : 0
  metadata {
    name = local.configuration.namespace
  }
}
