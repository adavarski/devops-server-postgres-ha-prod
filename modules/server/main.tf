# Create the server to run the wireguard client on
resource "hcloud_server" "server" {
  count       = var.num_servers

  name        = "${var.instance_name}-${count.index}"
  image       = var.instance_image
  server_type = var.instance_type
  location    = var.instance_location

  ssh_keys    = var.ssh_keys
}

resource "hcloud_server_network" "server_network" {
  count       = var.num_servers

  server_id   = hcloud_server.server[count.index].id
  network_id  = var.vpc_id
}
