cluster_name: k8s-cluster
name: k8s-cluster
enable_cluster_alerting: false
enable_cluster_monitoring: false
ignore_docker_version: true

nodes:
%{ for i, ip in k8s-node-ip ~}
%{ if i == 0 ~}
  - address: ${ip}
    hostname_override: node${i}
    user: test
    labels:
      worker: no
      location: nsk
    role: [controlplane, etcd]
%{ else ~}
  - address: ${ip}
    hostname_override: node${i}
    user: test
    labels:
      worker: yes
      location: nsk
    role: [worker]
%{ endif ~}
%{ endfor ~}

services:
  etcd:
    snapshot: true
    creation: 6h
    retention: 30h
  kube-controller:
    extra_args:
      terminated-pod-gc-threshold: 100
  kubelet:
    extra_args:
      max-pods: 250
  kube-api:
    service_cluster_ip_range: 10.43.0.0/16
    service_node_port_range: 30000-32767
    pod_security_policy: false

ingress:
  provider: nginx
  options:
    use-forwarded-headers: "true"
