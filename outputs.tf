output "instance_ip" {
  value       = module.tamr_vm.tamr_instance_internal_ip
  description = "An arbitrary value that changes each time the resource is replaced."
}

output "tamr_instance_self_link" {
  value       = module.tamr_vm.tamr_instance_self_link
  description = "full self link of created tamr vm"
}

output "tamr_service_account" {
  value       = module.iam.service_account_email
  description = "service account tamr is using"
}

# config files
# NOTE: these are very useful for debugging
output "tamr_config_file" {
  value       = module.tamr_vm.tamr_config_file
  description = "full tamr config file"
}

output "tmpl_dataproc_config" {
  value       = module.tamr_vm.tmpl_dataproc_config
  description = "dataproc config"
}

output "tmpl_statup_script" {
  value       = module.tamr_vm.tmpl_statup_script
  description = "rendered metadata startup script"
}
