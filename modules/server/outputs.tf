output "id" {
  value = hcloud_server.server.*.id
}

output "private_ip" {
  value = hcloud_server_network.server_network.*.ip
}

output "public_ip" {
  value = hcloud_server.server.*.ipv4_address
}