###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}
variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

#variable "vm_web_name" {
#  type        = string
#  default     = "netology-develop-platform-web"
#  description = "yandex_compute_instance_name"
#}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex_compute_instance_platform"
}

variable "vms_resources" {
  type        = map(map(number))
  description = "resources_vms"
  default     = {
   vm_web_resources = {
     cores         = 2 
     memory        = 1
     core_fraction = 5
   }
   vm_db_resources = {
     cores         = 2
     memory        = 2
     core_fraction = 20
   }
  }
 }


###ssh vars

variable "metadata" {
 description = "metadata for vms"
 type        = map(string)
 default     = {
   serial-port-enable = "1"
   ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJsCswnY+HhuNAd6iBtBzHpPMQg5IS6kMngZ0b9zIG+0 bobrik"
 }
}




#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJsCswnY+HhuNAd6iBtBzHpPMQg5IS6kMngZ0b9zIG+0 bobrik"
#  description = "ssh-keygen -t ed25519"
#}
