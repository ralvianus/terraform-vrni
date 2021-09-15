### vsphere variables
variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}
variable "network" {}

### appliance variables
variable "vm_name" {}
variable "remote_ovf_url" {}
variable "deployment_option" {}
variable "mgmt-ip" {}
variable "mgmt-mask" {}
variable "default-gw" {}

### initial config
variable "admin-password" {}

### dns config
variable "dns-server" {}
variable "domain" {}

## ntp configuration
variable "ntp" {}

## Proxy shared Secret
variable "Proxy_Shared_Secret" {}
