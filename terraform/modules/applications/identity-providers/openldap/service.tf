#apiVersion: v1
#kind: Service
#metadata:
#  name: openldap
#  labels:
#    app.kubernetes.io/name: openldap
#spec:
#  type: ClusterIP
#  ports:
#    - name: tcp-ldap
#      port: 1389
#      targetPort: tcp-ldap
#  selector:
#    app.kubernetes.io/name: openldap

resource "kubernetes_service" "this" {
  metadata {
    name = "openldap"
  }
  spec {
    selector = {
      app = kubernetes_deployment.this.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 389
      target_port = var.listen_port
    }

    type = "LoadBalancer"
  }
}
