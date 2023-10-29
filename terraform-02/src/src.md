***'''SRC'''***

output "Admin_info" { value = "${local.test_map["admin"]} is admin for ${local.test_list[2]} server based on OS ${local.servers.production.image} with ${local.servers.production.cpu} vcpu, ${local.servers.production.ram} ram and ${length(local.servers.production.disks)} disks"}
