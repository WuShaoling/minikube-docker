#!/bin/bash

mount --make-shared /

export CNI_BRIDGE_NETWORK_OFFSET="0.0.1.0"
/dindnet &> /var/log/dind.log 2>&1 < /dev/null &

dockerd \
  --host=unix:///var/run/docker.sock \
  --host=tcp://0.0.0.0:2375 \
  &> /var/log/docker.log 2>&1 < /dev/null &

echo "start docker load"
docker load < /root/docker_images/k8s-dns-dnsmasq-nanny-amd64.tar
docker load < /root/docker_images/k8s-dns-kube-dns-amd64.tar
docker load < /root/docker_images/k8s-dns-sidecar-amd64.tar
docker load < /root/docker_images/kube-addon-managerkube-addon-manage
docker load < /root/docker_images/kubernetes-dashboard-amd64.tar
docker load < /root/docker_images/pause-amd64.tar
docker load < /root/docker_images/storage-provisioner.tar
echo "docker load ok"

minikube start --vm-driver=none \
 --extra-config=apiserver.Admission.PluginNames=Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,GenericAdmissionWebhook,ResourceQuota \
 &> /var/log/minikube-start.log 2>&1 < /dev/null

kubectl config view --merge=true --flatten=true > /kubeconfig

/usr/local/bin/server
