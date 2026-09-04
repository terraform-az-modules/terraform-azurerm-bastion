variable "name" {
  type        = string
  default     = "app"
  description = "Name (e.g. app or cluster)."
}

variable "environment" {
  type        = string
  default     = "app-test"
  description = "Environment (e.g. prod, dev, staging)."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment"]
  description = "Label order."
}

variable "managedby" {
  type        = string
  default     = "Az-Terraform Modules"
  description = "ManagedBy tag value."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Resource group name."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure location."
}

variable "public_ip_allocation_method" {
  type        = string
  default     = "Static"
  description = "Public IP allocation method."
}

variable "public_ip_sku" {
  type        = string
  default     = "Standard"
  description = "Public IP SKU."
}

variable "enable_copy_paste" {
  type        = bool
  default     = true
  description = "Enable copy/paste for Bastion."
}

variable "enable_file_copy" {
  type        = bool
  default     = false
  description = "Enable file copy for Bastion. Standard/Premium only."
}

variable "bastion_host_sku" {
  type        = string
  default     = "Basic"
  description = "Bastion SKU: Basic, Standard, or Premium."
}

variable "enable_ip_connect" {
  type        = bool
  default     = false
  description = "Enable IP connect feature."
}

variable "scale_units" {
  type        = number
  default     = 2
  description = "Scale units for Standard SKU."
}

variable "enable_shareable_link" {
  type        = bool
  default     = false
  description = "Enable shareable link. Standard/Premium only."
}

variable "enable_tunneling" {
  type        = bool
  default     = false
  description = "Enable tunneling. Standard/Premium only."
}

variable "enable_kerberos" {
  type        = bool
  default     = false
  description = "Enable Kerberos authentication. Standard/Premium only."
}

variable "private_only_enabled" {
  type        = bool
  default     = false
  description = "Deploy Bastion in private-only mode. Premium only."
}

variable "create_public_ip" {
  type        = bool
  default     = true
  description = "Create a public IP for Bastion. Must be false for private-only Premium deployment."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent module creation."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azurerm-bastion.git"
  description = "Module repository."
}

variable "ddos_protection_mode" {
  type        = string
  default     = "VirtualNetworkInherited"
  description = "Public IP DDoS protection mode."
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "DDoS protection plan ID."
}

variable "zone" {
  type        = string
  default     = null
  description = "Zone for the public IP."
}

variable "domain_name_label" {
  type        = string
  default     = null
  description = "Public IP DNS label."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "AzureBastionSubnet ID."
}

variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "AzureDiagnostics or Dedicated."
}

variable "diagnostic_setting_enable" {
  type    = bool
  default = true
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}

variable "log_enabled" {
  type        = bool
  default     = true
  description = "Enable Bastion logs."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "Storage account ID for diagnostics."
}

variable "eventhub_name" {
  type        = string
  default     = null
  description = "Event Hub name for diagnostics."
}

variable "eventhub_authorization_rule_id" {
  type        = string
  default     = null
  description = "Event Hub authorization rule ID for diagnostics."
}

variable "metric_enabled" {
  type        = bool
  default     = true
  description = "Enable Bastion metrics."
}

variable "enable_public_ip_diagnostics" {
  type        = bool
  default     = true
  description = "Enable diagnostics for the Bastion public IP resource."
}

variable "bastion_log_categories" {
  type        = list(string)
  default     = ["BastionAuditLogs"]
  description = "Bastion diagnostic log categories."
}

variable "bastion_metric_categories" {
  type        = list(string)
  default     = ["AllMetrics"]
  description = "Bastion diagnostic metric categories."
}

variable "pip_logs" {
  type = object({
    enabled        = bool
    category       = optional(list(string))
    category_group = optional(list(string))
  })
  default = {
    enabled        = true
    category_group = ["AllLogs"]
  }
}
