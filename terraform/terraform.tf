terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.92.0"
}

provider "yandex" {
 service_account_key_file = "/home/vagrant/key.json"
 cloud_id  = "${var.cloud_id}"
 folder_id = "${var.folder_id}"
 zone      = "${var.zone}"
}