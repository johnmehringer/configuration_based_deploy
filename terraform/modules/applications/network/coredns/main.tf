locals {
  service_name        = indent(2, yamlencode({"name":var.service_name})
  service_type        = yamlencode({"serviceType":var.service_type})
  service_annotations = indent(2, var.service_annotations != null
                                    ? yamlencode({"annotations":var.service_annotations})
                                    : "annotations: {}"
                              )
  service_load_balancer_ip = indent(2, var.service_load_balancer_ip != null
                                         ? yamlencode({"loadBalancerIP":var.load_balancer_ip})
                                         : ""
                                   )
}

resource "helm_release" "coredns" {
  name       = "coredns"
  chart      = "coredns"
  repository = "https://coredns.github.io/helm"
  version    = var.chart_version
  namespace  = var.namespace

  values = [ templatefile("${path.module}/helm_values.yaml.tpl",
                           {
                             isClusterService      = var.is_cluster_service
                             serviceName           = local.service_name
                             serviceType           = local.service_type
                             serviceLoadBalancerIP = local.service_load_balancer_ip
                             serviceAnnotations    = local.service_annotations 
                           }
                         )
           ]
}
