locals {
  database_host     = (var.helm_name == "postgresql-ha"
                        ? "postgresql-ha-pgpool.${var.namespace}.svc"
                        : "${var.helm_name}-postgresql-ha-pgpool.${var.namespace}.svc"
                      )
  database_port     = "5432"
  database_name     = var.database_name
  database_user     = var.database_user
  database_password = kubernetes_secret.passwords.data.password
  database_url      = "postgresql://${local.database_user}:${local.database_password}@${local.database_host}:5432/${local.database_name}"
}

resource "kubernetes_secret" "passwords" {
  metadata {
    name = var.passwords_secret_name
    namespace = var.namespace
  }
  
  data = {
    "postgres-password" = random_password.postgres_password.result
    "repmgr-password"   = random_password.repmgr_password.result
    "password"          = random_password.database_password.result
  }
}

resource "helm_release" "postgresql-ha" {
  name       = var.helm_name
  chart      = "postgresql-ha"
  repository = "https://charts.bitnami.com/bitnami/"
  version    = var.chart_version
  namespace  = var.namespace

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             database_port         = local.database_port
                             database_name         = local.database_name
                             database_user         = local.database_user
                             database_password     = local.database_password
                             passwords_secret_name = kubernetes_secret.passwords.metadata.0.name
                             metrics_enabled       = var.metrics_enabled
                             volume_storage_size   = var.volume_storage_size
                             volume_storage_class  = var.volume_storage_class
                             replica_count         = var.replica_count
                             architecture          = (var.replica_count > 0 
                                                       ? "replication"
                                                       : "standalone"
                                                     )
                           }
                         ) 
           ]

  depends_on = [ kubernetes_secret.passwords ]
}
