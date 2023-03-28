#---
# kind: StorageClass
# apiVersion: storage.k8s.io/v1
# metadata:
#   name: longhorn
# provisioner: driver.longhorn.io
# allowVolumeExpansion: true
# parameters:
#   numberOfReplicas: "3"
#   staleReplicaTimeout: "2880" # 48 hours in minutes
#   fromBackup: ""
#   diskSelector: "ssd,fast"
#   nodeSelector: "storage,fast"
#   recurringJobs: '[{"name":"snap", "task":"snapshot", "cron":"*/1 * * * *", "retain":1},
#                    {"name":"backup", "task":"backup", "cron":"*/2 * * * *", "retain":1,
#                     "labels": {"interval":"2m"}}]'

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class
resource "kubernetes_storage_class" "standard" {
  metadata {
    name = join("-", [var.namespace, "standard"])
  }
  storage_provisioner = "driver.longhorn.io"
  reclaim_policy      = "Retain"
  parameters = {
    numberOfReplicas = "3"
    staleReplicaTimeout = "1440"
  }
  #mount_options = ["file_mode=0600", "dir_mode=0755"]
  #mount_options = ["file_mode=0700", "dir_mode=0755", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]

  depends_on = [ helm_release.longhorn ]
}

resource "kubernetes_storage_class" "ephemeral" {
  metadata {
    name = join("-", [var.namespace, "ephemeral"])
  }
  storage_provisioner = "driver.longhorn.io"
  reclaim_policy      = "Delete"
  parameters = {
    numberOfReplicas = "1"
    staleReplicaTimeout = "1440"
  }
  #mount_options = ["file_mode=0600", "dir_mode=0755"]
  #mount_options = ["file_mode=0700", "dir_mode=0755", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]

  depends_on = [ helm_release.longhorn ]
}
