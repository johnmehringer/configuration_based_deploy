output "namespace" {
  value = local.namespace
}

output "database_host" {
  value = module.this.database_host
}

output "database_port" {
  value = module.this.database_port
}

output "database_name" {
  value = module.this.database_name
}

output "database_user" {
  value = module.this.database_user
}

output "database_password" {
  value = module.this.database_password
  sensitive = true
}
