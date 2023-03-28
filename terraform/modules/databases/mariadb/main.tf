resource "kubernetes_secret" "passwords" {
  metadata {
    name = var.passwords_secret_name
    namespace = var.namespace
  }
  
  data = {
    "mariadb-root-password"        = random_id.mysql_root_password.hex
    "mariadb-replication-password" = random_id.mysql_replication_password.hex
    "mariadb-password"             = random_id.mysql_user_password.hex
  }
}

resource "helm_release" "mariadb" {
  name       = var.helm_name
  chart      = "mariadb"
  repository = "https://charts.bitnami.com/bitnami/"
  version    = var.chart_version
  namespace  = var.namespace

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             database_name           = var.database_name
                             passwords_secret_name   = var.passwords_secret_name
                             metrics_enabled         = var.metrics_enabled
                             volume_size             = var.volume_size
                             volume_storage_class    = var.volume_storage_class
                             secondary_replica_count = var.secondary_replica_count
                             architecture            = (var.secondary_replica_count > 0 
                                                         ? "replication"
                                                         : "standalone"
                                                       )
                           }
                         ) 
           ]

  depends_on = [ kubernetes_secret.passwords ]
}
