output "database_host" {
  value = local.database_host
}

output "database_port" {
  value = local.database_port
}

output "database_name" {
  value = local.database_name
}

output "database_user" {
  value = local.database_user
}

output "database_password" {
  value = local.database_password
  sensitive = true
}

output "database_url" {
  value = local.database_url
  sensitive = true
}
