locals {
  cluster_configuration = yamldecode(file("configuration/cluster_metadata.yaml"))
  
  cluster_name = local.cluster_configuration.name
}

provider "helm" {
  kubernetes {
    config_context = local.cluster_name
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_context = local.cluster_name
  config_path = "~/.kube/config"
}
