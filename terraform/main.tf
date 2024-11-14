data "yandex_compute_image" "my_image" {
  family = var.image_family
}

data "yandex_vpc_network" "default" {
  name = var.vpc_network
}

data "yandex_vpc_subnet" "default" {
  for_each = toset(var.zones)
  name = "${data.yandex_vpc_network.default.name}-${each.key}"
}

# output "subnet_ids" {
#     value = data.yandex_vpc_subnet.default[var.zone].subnet_id
# }

resource "yandex_compute_instance" "vm" {
  count = length(var.vm_names)
  name = var.vm_names[count.index]
  resources {
      cores  = 2
      memory = 8
  }

  boot_disk {
      initialize_params {
          image_id = "${data.yandex_compute_image.my_image.image_id}"
          size     =  20
      }
  }

  network_interface {
      subnet_id = "${data.yandex_vpc_subnet.default[var.zone].subnet_id}"
      nat       = true
  }

  scheduling_policy {
      preemptible = true
  }

  metadata = {
      user-data = file(var.new_user)
  }

  provisioner "local-exec" {
    working_dir = "../ansible/"
    command     = "sleep 60 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml -i '${self.network_interface.0.nat_ip_address},' -u test --private-key ${var.private_key_file}"

    connection {
      type        = "ssh"
      user        = "test"
      # agent       = true
      private_key = "${file(var.private_key_file)}"
      host        = "${self.network_interface.0.nat_ip_address}"
    }
  }
}

resource "local_file" "rke_cluster_yml" {
  content = templatefile("cluster.tpl",
    {
      # k8s_master_node = yandex_compute_instance.vm[0].network_interface.0.nat_ip_address
      k8s-node-ip = [
        for instance in yandex_compute_instance.vm[*] :
        join(": ", [instance.network_interface.0.nat_ip_address])
      ]
    }
  )
  filename = "../rke_config/cluster.yml"
}

output "instance_output" {
  value = [
    for instance in yandex_compute_instance.vm[*] :
    join(": ", [instance.name, instance.hostname, instance.network_interface.0.ip_address, instance.network_interface.0.nat_ip_address])
  ]
}
