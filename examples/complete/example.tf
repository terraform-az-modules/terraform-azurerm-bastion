provider "azurerm" {
  features {}
}

locals {
  name           = "app"
  environment    = "test"
  label_order    = ["name", "environment", "location"]
  vnet_cidr      = "10.0.0.0/16"
  bastion_cidr   = "10.0.1.0/26"
  vm_cidr        = "10.0.2.0/24"
  admin_username = "azureadmin"
}

##-----------------------------------------------------------------------------
## Resource Group
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azurerm"
  version     = "1.0.4"
  name        = local.name
  environment = local.environment
  label_order = local.label_order
  location    = "canadacentral"
}

##-----------------------------------------------------------------------------
## Virtual Network
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.4"
  name                = local.name
  environment         = local.environment
  label_order         = local.label_order
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = [local.vnet_cidr]
}

##-----------------------------------------------------------------------------
## Subnets
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.3"
  environment          = local.environment
  label_order          = local.label_order
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "AzureBastionSubnet"
      subnet_prefixes = [local.bastion_cidr]
    },
    {
      name            = "vm-subnet"
      subnet_prefixes = [local.vm_cidr]
    }
  ]
}

##-----------------------------------------------------------------------------
## Network Security Group
##-----------------------------------------------------------------------------
module "network_security_group" {
  source              = "terraform-az-modules/nsg/azurerm"
  version             = "1.0.7"
  environment         = local.environment
  label_order         = local.label_order
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_ids          = [module.subnet.subnet_ids["vm-subnet"]]
  inbound_rules = [
    {
      name                       = "ssh-from-bastion"
      priority                   = 100
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = local.bastion_cidr
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH from Bastion subnet"
    }
  ]
  enable_diagnostic = false
}

##-----------------------------------------------------------------------------
## Virtual Machine
##-----------------------------------------------------------------------------
module "virtual_machine" {
  source                     = "terraform-az-modules/virtual-machine/azurerm"
  version                    = "1.3.0"
  name                       = local.name
  environment                = local.environment
  label_order                = local.label_order
  resource_group_name        = module.resource_group.resource_group_name
  location                   = module.resource_group.resource_group_location
  is_vm_windows              = true
  subnet_id                  = module.subnet.subnet_ids["vm-subnet"]
  network_security_group_id  = module.network_security_group.network_security_group_id
  vm_size                    = "Standard_B1s"
  computer_name              = "app-win-comp"
  admin_username             = local.admin_username
  admin_password             = random_password.vm.result
  image_publisher            = "MicrosoftWindowsServer"
  image_offer                = "WindowsServer"
  image_sku                  = "2019-datacenter"
  image_version              = "latest"
  private_ip_addresses       = ["10.0.2.4"]
  disk_size_gb               = 127
  enable_disk_encryption_set = false
  diagnostic_setting_enable  = false
}

resource "random_password" "vm" {
  length  = 20
  special = true
}

##-----------------------------------------------------------------------------
## Bastion
##-----------------------------------------------------------------------------
module "bastion" {
  depends_on = [
    module.subnet,
    module.virtual_machine,
  ]

  source              = "./../../"
  name                = local.name
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.subnet.subnet_ids["AzureBastionSubnet"]

  diagnostic_setting_enable = false
}
