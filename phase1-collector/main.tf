terraform {
	required_providers {
		vsphere = "~> 2.0"
	}
}
provider "vsphere" {
	vsphere_server		= "vcenter.lab01.one"
	user			= "administrator@vsphere.local"
	password		= "VMware1!SDDC"
	allow_unverified_ssl	= true
}

module "vrni-platform" {
	source		= "./module-vrni-platform"

	### vsphere variables
	datacenter	= "lab01"
	cluster		= "mgmt"
	datastore	= "vsanDatastore "
	network		= "pg-mgmt"

	### appliance variables
	vm_name		= "vrnic01.lab01.one"
	deployment_option = "medium"
	remote_ovf_url	= "http://172.16.10.1:9000/iso/VMware-vRealize-Network-Insight-6.3.0.1625072760-collector.ova"
	mgmt-ip		= "172.16.10.122"
	mgmt-mask	= "255.255.255.0"
	default-gw	= "172.16.10.1"

	### initial config
	admin-password	= "VMware1!SDDC"

	### DNS config
	dns-server = "172.16.10.1"
	domain = "lab01.one"

	### Proxy Shared Secret
	Proxy_Shared_Secret = ""
}
