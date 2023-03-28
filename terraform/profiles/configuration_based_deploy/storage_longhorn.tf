module "storage_longhorn" {
  for_each = {for key,profile in local.deployment_profiles :
               key => profile if profile == "longhorn"
             }

  source = "../storage/longhorn"
  configuration = local.configurations[each.key]
}
