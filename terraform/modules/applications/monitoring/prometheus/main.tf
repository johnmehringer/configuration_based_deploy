locals {
  rules_group_files = flatten([for group in var.rules_groups : 
                                 fileset(path.module, "rules/${group}/*.rules")
                              ])

  additional_scrape_configs = (length(var.additional_scrape_configs) > 0
                                ? indent(6,join("\n", ["", yamlencode(var.additional_scrape_configs)]))
                                : ""
                              )
}

resource "kubernetes_config_map" "prometheus_rules" {
  metadata {
    name      = "prometheus-rules"
    namespace = var.namespace
  }

  data = {
    for s in local.rules_group_files :
      basename(s) => file(s)
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = var.chart_version
  namespace  = var.namespace

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             statefulSetEnabled             = var.statefulset_enabled
                             serverVolumeSize               = var.server_volume_size
                             serverVolumeStorageClass       = var.server_volume_storage_class
                             alertmanagerEnabled            = var.alertmanager_enabled
                             alertmanagerVolumeSize         = var.alertmanager_volume_size
                             alertmanagerVolumeStorageClass = var.alertmanager_volume_storage_class
                             additionalScrapeConfigJobs     = local.additional_scrape_configs
                             nodeExporterHostRootFsMount    = var.node_exporter_host_root_fs_mount
                           }
                         )
           ]
}
