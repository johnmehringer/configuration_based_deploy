module "configuration_based_deploy" {
  source = "../../profiles/configuration_based_deploy"
  configuration_path = "${path.module}/configuration"
}
