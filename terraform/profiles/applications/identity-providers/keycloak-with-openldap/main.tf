locals {
  configuration = merge(
                          yamldecode(file("${path.module}/configuration.yaml")),
                          var.configuration
                       )
  namespace = (var.custom_namespace == null 
                ? kubernetes_namespace.this.0.metadata.0.name
                : var.custom_namespace
              )
}

module ldap {
  source = "../../../../modules/applications/identity-providers/openldap"

  namespace = local.namespace
}

module postgresql {
  source = "../../../databases/postgresql"

  configuration = {
    namespace            = local.namespace
    volume_storage_space = local.configuration.database_volume_storage_space
    database_user        = local.configuration.database_user 
    database_name        = local.configuration.database_name
  }

  storage_class_mapping = var.storage_class_mapping
  custom_namespace      = local.namespace 
}

module keycloak {
  source = "../../../../modules/applications/identity-providers/keycloak"

  namespace         = local.namespace
  database_host     = module.postgresql.database_host
  database_port     = module.postgresql.database_port
  database_name     = module.postgresql.database_name
  database_user     = module.postgresql.database_user
  database_password = module.postgresql.database_password

  depends_on = [ module.postgresql ]
}
