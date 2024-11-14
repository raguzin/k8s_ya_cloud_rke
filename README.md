## Set k8s for Yandex Cloud use RKE

* Ubuntu v22.04 (2CPU, 20GB HDD, 6Gb RAM)
* k8s v1.25.9

## Install requrements

### Ansible install (terminal_host who ssh connect to VM's cluster)
```Bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```

### Install RKE (terminal_host who ssh connect to VM's cluster)
```Bash
curl -s https://api.github.com/repos/rancher/rke/releases/latest | grep download_url | grep amd64 | cut -d '"' -f 4 | wget -qi -
chmod +x rke_linux-amd64
sudo mv rke_linux-amd64 /usr/local/bin/rke
rke --version
rke config --list-version --all
```
### Install Kubectl (master node)
```Bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
```

### Configure terraform provider on host
Create ~/.terraformrc
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
} 
```

## Deploy cluster

### Initialisation VM's and Configuration (dynamic inventory Ansible)
```Bash
git clone https://github.com/raguzin/k8s_ya_cloud_rke.git
cd terraform
terraform init
terraform apply
```

### Deploy k8s
```Bash
cd ../rke_config
rke up --ssh-agent-auth --ignore-docker-version
```

### Set kubeconfig
```Bash
mkdir ~/.kube/
cat kube_config_cluster.yml >~/.kube/config
kubectl cluster-info
kubectl get nodes -owide
```

### Install StorageClass in Cluster
```Bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl get storageclass
```

## Remove cluster
```Bash
#exit from cluster node
pwd rke_config
rke remove --ssh-agent-auth --ignore-docker-version
cd ../terraform  
terraform destroy
```
