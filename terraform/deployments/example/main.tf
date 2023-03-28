locals {
  # load balancing
  deploy_metallb    = true

  # storage
  deploy_longhorn   = true
  deploy_minio      = false

  # monitoring
  deploy_prometheus = true
  deploy_grafana    = true

  # applications
  deploy_mariadb  = true
}

# ----------------------------------------------------------
# -- load balancing --
module "metallb" {
  count  = local.deploy_metallb ? 1 : 0
  source = "../../loadbalancing/metallb"
  configuration = file("./configuration/metallb.yaml")
}

# ----------------------------------------------------------
# -- storage --
module "longhorn" {
  count  = local.deploy_longhorn ? 1 : 0
  source = "../../storage/longhorn"
}

module "minio" {
  count  = local.deploy_minio ? 1 : 0
  source = "../../storage/minio"
}

# ----------------------------------------------------------
# -- monitoring --
resource kubernetes_namespace "monitoring" {
  metadata {
    name = "monitoring"
  }
}

module "prometheus" {
  count  = local.deploy_prometheus ? 1 : 0
  source = "../../applications/prometheus"

  namespace                   = kubernetes_namespace.monitoring.metadata.0.name
  server_volume_storage_class = "longhorn-standard"

  additional_scrape_configs     = (fileexists("./configuration/prometheus.yaml")
                                    ? yamldecode(file("./configuration/prometheus.yaml")).scrape_configs
                                    : null
                                  )

  depends_on = [ module.longhorn ]
}

module "grafana" {
  count  = local.deploy_grafana ? 1 : 0
  source = "../../applications/grafana"

  namespace            = kubernetes_namespace.monitoring.metadata.0.name
  persistence_enabled  = true
  volume_storage_class = "longhorn-standard"

  depends_on = [ module.longhorn ]
}

# ----------------------------------------------------------
# -- applications --
module "mariadb_example" {
  count  = local.deploy_mariadb_fivem-fxserver ? 1 : 0
  source = "../../applications/mariadb"

  namespace            = "mariadb-example"
  database_name        = "es_extended"
  volume_storage_class = "longhorn-ephemeral"

  depends_on = [ module.longhorn ]
}
