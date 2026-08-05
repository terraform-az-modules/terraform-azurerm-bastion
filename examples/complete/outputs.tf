##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------
output "bastion_dns_name" {
  value       = module.bastion.dns_name
  description = "Specifies the name of the bastion host"
}

output "bastion_id" {
  value       = module.bastion.id
  description = "Specifies the name of the bastion host"
}

output "vm_id" {
  value       = module.virtual_machine.windows_virtual_machine_id
  description = "ID of the example virtual machine."
}

output "vm_private_ip_addresses" {
  value       = module.virtual_machine.network_interface_private_ip_addresses
  description = "Private IP addresses of the example virtual machine."
}
