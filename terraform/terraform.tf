terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.92.0"
}

provider "yandex" {
#  token     = "t1.9euelZrMm4_Gj47KzY2KmpDOzM2Lyu3rnpWax86PlouMkZOKiZLJnYqXmI3l8_dwIjpM-e96L2cw_d3z9zBRN0z573ovZzD9zef1656Vmp2YiY7HyMiSkM-bjYuakZ2N7_zF656Vmp2YiY7HyMiSkM-bjYuakZ2N.GMOvTnsM0SuwQXqpYbUeeDLOzp-4zrOg7dspuJP4VS0Fap7TnxcXMzcVwr7zAlmIQ0ucyhj9eL1VAYqnk73gDA"
 cloud_id  = "${var.cloud_id}"
 folder_id = "${var.folder_id}"
 zone      = "${var.zone}"
}