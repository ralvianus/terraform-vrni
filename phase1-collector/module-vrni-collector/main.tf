data "vsphere_datacenter" "datacenter" {
	name          = var.datacenter
}

data "vsphere_datastore" "datastore" {
	name          = var.datastore
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
	name          = var.cluster
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
	name          = var.host
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
	name          = var.network
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_ovf_vm_template" "ovf" {
	name             = var.vm_name
	resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
	datastore_id     = data.vsphere_datastore.datastore.id
	host_system_id   = data.vsphere_host.host.id
	remote_ovf_url   = var.remote_ovf_url

	ovf_network_map = {
		"VM Network" = data.vsphere_network.network.id
	}
}

resource "vsphere_virtual_machine" "vm" {
	datacenter_id	= data.vsphere_datacenter.datacenter.id
	name		= data.vsphere_ovf_vm_template.ovf.name
	num_cpus	= data.vsphere_ovf_vm_template.ovf.num_cpus
	memory		= data.vsphere_ovf_vm_template.ovf.memory
	guest_id	= data.vsphere_ovf_vm_template.ovf.guest_id
	wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0
	resource_pool_id = data.vsphere_ovf_vm_template.ovf.resource_pool_id
	datastore_id     = data.vsphere_ovf_vm_template.ovf.datastore_id

	dynamic "network_interface" {
		for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
		content {
			network_id = network_interface.value
		}
	}
	ovf_deploy {
		disk_provisioning	= "thin"
		ovf_network_map		= data.vsphere_ovf_vm_template.ovf.ovf_network_map
		deployment_option = var.deployment_option
		remote_ovf_url		= data.vsphere_ovf_vm_template.ovf.remote_ovf_url
	}
	vapp {
		properties = {
			"IP_Address"	= var.mgmt-ip
			"Netmask"	= var.mgmt-mask
			"Default_Gateway"	= var.default-gw
			"DNS" = var.dns-server
			"Domain_Search" = var.domain
			"NTP" = var.ntp
			"SSH_User_Password" = var.admin-password
			"CLI_User_Password" = var.admin-password
			"Auto-Configure" = "True"
			"Proxy_Shared_Secret" = var.Proxy_Shared_Secret
		}
	}
}
