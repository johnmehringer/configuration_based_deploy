locals {
  


}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  chart      = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  version    = var.chart_version
  namespace  = var.namespace

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             adminUser         = var.admin_user
                             adminPassword     = random_password.admin.result
                             database_host     = var.database_host
                             database_port     = var.database_port
                             database_name     = var.database_name
                             database_user     = var.database_user
                             database_password = var.database_password
                           }
                         ) 
           ]
}
