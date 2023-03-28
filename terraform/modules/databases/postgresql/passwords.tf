resource random_password "postgres_password" {
  keepers = {
    password_version = var.password_version
  }

  length  = 32
  special = false
}

resource random_password "repmgr_password" {
  keepers = {
    password_version = var.password_version
  }

  length  = 32
  special = false
}

resource random_password "database_password" {
  keepers = {
    password_version = var.password_version
  }

  length  = 32
  special = false
}
