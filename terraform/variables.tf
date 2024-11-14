variable "cloud_id" {
  description = "cloud"
  type        = string
}

variable "folder_id" {
  description = "folder"
  type        = string
}

variable "vpc_network" {
     type = string
     default = "default"
}

variable "zone" {
  description = "zone"
  type        = string
  default     = "ru-central1-a"
}

variable "zones" {
  description = "Network zones"
  type        = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "image_family" {
  description = "zone"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_names" {
  description = "VM Names"
  type        = list(string)
  default     = ["std-00-test-vm-1", "std-00-test-vm-2", "std-00-test-vm-3"]
}

variable "new_user" {
  type    = string
  default = "meta.txt"
}

variable "private_key_file" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}