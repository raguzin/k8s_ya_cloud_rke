terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.92.0"
}

provider "yandex" {
 cloud_id  = "${var.cloud_id}"
 folder_id = "${var.folder_id}"
 zone      = "${var.zone}"
}