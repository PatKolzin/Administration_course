
output "external_ip_address_netology-develop-platform-web" {
  value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
}


output "external_ip_address_netology-develop-platform-db" {
  value = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
}


output "Admin_info" { value = "${local.test_map["admin"]} is admin for ${local.test_list[2]} server based on OS ${local.servers.production.image} with ${local.servers.production.cpu} vcpu, ${local.servers.production.ram} ram and ${length(local.servers.production.disks)} disks"}
