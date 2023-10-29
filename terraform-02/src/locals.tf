locals {
 project = "netology-develop-platform"
 web = "web"
 db  = "db"
 vm_instance_name_web = "${local.project}-${local.web}"
 vm_instance_name_db  = "${local.project}-${local.db}"
}
