##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------
output "dns_name" {
  value       = try(azurerm_bastion_host.main[0].dns_name, null)
  description = "DNS name of the Bastion host."
}

output "id" {
  value       = try(azurerm_bastion_host.main[0].id, null)
  description = "Resource ID of the Bastion host."
}

output "public_ip_id" {
  value       = try(azurerm_public_ip.pip[0].id, null)
  description = "Resource ID of the Bastion public IP, if created."
}

output "private_only_enabled" {
  value       = var.private_only_enabled
  description = "Whether Bastion is deployed in private-only mode."
}
