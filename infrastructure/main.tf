
# Get the network id for the postgres cluster to attach to
data "hcloud_network" "network" {
  name = "vpc"
}

# SSH key for initializing the node with
data "hcloud_ssh_keys" "all_keys" {
}

module "postgres_master" {
  source      = "../modules/server"
  num_servers = 1

  hcloud_token   = var.hcloud_token
  instance_name  = "postgres-master"
  instance_type  = "cx41"
  vpc_id         = data.hcloud_network.network.id
  ssh_keys       = data.hcloud_ssh_keys.all_keys.ssh_keys.*.id
}

// Prepare the inventory files for the postgres master for ansible
resource "local_file" "postgres_master_inventory" {
  count = 1

  content = <<-DOC
    [master]
    ${module.postgres_master.public_ip[count.index]} ansible_host=${module.postgres_master.public_ip[count.index]}

    [etcd_cluster]
    ${module.postgres_master.public_ip[count.index]} ansible_host=${module.postgres_master.public_ip[count.index]}
    
    [balancers]
    ${module.postgres_master.public_ip[count.index]} ansible_host=${module.postgres_master.public_ip[count.index]}
    DOC
  filename = "../inventory/postgres_master-${count.index}.ini"


}


# Finally create the postgres slave nodes
module "postgres_slave" {
  source      = "../modules/server"
  num_servers = 2

  hcloud_token   = var.hcloud_token
  instance_name  = "postgres-slave"
  instance_type  = "cx41"
  vpc_id         = data.hcloud_network.network.id
  ssh_keys       = data.hcloud_ssh_keys.all_keys.ssh_keys.*.id
}

// Prepare the inventory files for the slave nodes for ansible
resource "local_file" "postgres_slave_inventory" {
  count = 2

  content = <<-DOC
    [replica]
    ${module.postgres_slave.public_ip[count.index]} ansible_host=${module.postgres_slave.public_ip[count.index]}

    [etcd_cluster]
    ${module.postgres_slave.public_ip[count.index]} ansible_host=${module.postgres_slave.public_ip[count.index]}
 
    [balancers]
    ${module.postgres_slave.public_ip[count.index]} ansible_host=${module.postgres_slave.public_ip[count.index]}
   DOC

  filename = "../inventory/postgres_slave-${count.index}.ini"
  
}

// Prepare the inventory files for the postgres for ansible
resource "local_file" "children_inventory" {
  content = <<-DOC
  [postgres_cluster:children]
    master
    replica
  DOC
  filename = "../inventory/postgres_children.ini"

}


