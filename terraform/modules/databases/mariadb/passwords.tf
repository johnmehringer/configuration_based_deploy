resource random_id "mysql_root_password" {
  keepers = {
    password_version = var.password_version
  }

  byte_length = 16
}

resource random_id "mysql_user_password" {
  keepers = {
    password_version = var.password_version
  }

  byte_length = 16
}

resource random_id "mysql_replication_password" {
  keepers = {
    password_version = var.password_version
  }

  byte_length = 16
}
