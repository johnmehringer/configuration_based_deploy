resource random_password "admin" {
  keepers = {
    password_version = var.password_version
  }

  length  = 32
  special = false
}

resource "kubernetes_secret" "passwords" {
  metadata {
    name = var.passwords_secret_name
    namespace = var.namespace
  }
  
  data = {
    "keycloack-admin-password" = random_password.admin.result
  }
}
