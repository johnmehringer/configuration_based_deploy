resource "kubernetes_deployment" "this" {
  metadata {
    name      = "openldap"
    namespace = var.namespace
    labels = {
      app = "openldap"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "openldap"
      }
    }

    template {
      metadata {
        labels = {
          app = "openldap"
        }
      }

      spec {
        container {
          image = var.container_image
          name  = "openldap"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            tcp_socket {
                port = var.listen_port
              }

            initial_delay_seconds = 3
            period_seconds        = 30
          }


          env {
            name  = "LDAP_ADMIN_USERNAME"
            value = "admin"
          }
          env {
            name  = "LDAP_ADMIN_PASSWORD"
            value = "abc123"
          }
#          env:
#            - name: LDAP_ADMIN_USERNAME
#              value: "admin"
#            - name: LDAP_ADMIN_PASSWORD
#              valueFrom:
#                secretKeyRef:
#                  key: adminpassword
#                  name: openldap
#            - name: LDAP_USERS
#              valueFrom:
#                secretKeyRef:
#                  key: users
#                  name: openldap
#            - name: LDAP_PASSWORDS
#              valueFrom:
#                secretKeyRef:
#                  key: passwords
#                  name: openldap
#          ports:
#            - name: tcp-ldap
#              containerPort: 1389
          port {
             name = "tcp-ldap"
             container_port = var.listen_port    
          }
        }
      }
    }
  }
}
