# raspberry-pi-arm64-kubernetes
Raspberry Pi arm64 Kubernetes Cluster

```
# dd if=2020-05-27-raspios-buster-arm64.img of=/dev/mmcblk0 bs=65536
# apt full-upgrade 

# systemctl stop dhcpcd5.service 
# systemctl disable dhcpcd5.service 
# systemctl stop dhcpcd.service 
# systemctl disable dhcpcd.service 

#vs# systemctl disable NetworkManager.service 
#vs# systemctl mask NetworkManager.service 
#vs# systemctl status networking.service 
#vs# systemctl restart networking.service 

# apt install -y network-manager
# systemctl enable NetworkManager.service

# ifup eth0

# systemctl enable multi-user.target
# systemctl isolate multi-user.target
# systemctl enable multi-user.target
# systemctl set-default multi-user.target
# shutdown -r now

# apt install -y openssh-server
# dpkg -L openssh-server
# systemctl enable ssh.service 
# systemctl start ssh.service 

# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# cat > /etc/apt/sources.list.d/kubernetes.list << EOF
> deb http://apt.kubernetes.io/ kubernetes-xenial main
> EOF

# apt install -y ntp

# cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
> net.bridge.bridge-nf-call-ip6tables = 1
> net.bridge.bridge-nf-call-iptables = 1
> EOF

# apt-get update && sudo apt-get install -y apt-transport-https curl

# apt install -y docker.io
# cat > /etc/docker/daemon.json << EOF
> {
>   "exec-opts": ["native.cgroupdriver=systemd"],
>   "log-driver": "json-file",
>   "log-opts": {
>     "max-size": "100m"
>   },
>   "storage-driver": "overlay2"
> }
> EOF
# apt-get install -y kubelet kubeadm kubectl

# systemctl stop dphys-swapfile.service
# swapoff -a
# systemctl stop dphys-swapfile.service
# systemctl disable dphys-swapfile.service
# systemctl mask dphys-swapfile.service
# apt remove --purge dphys-swapfile

# systemctl stop alsa-state.service
# systemctl disable alsa-state.service
# iptables -L -n
# systemctl daemon-reload
# systemctl status kubelet
# systemctl restart kubelet

# cat > /etc/apt/sources.list.d/docker.list << EOF
> deb [arch=arm64] https://download.docker.com/linux/raspbian buster stable
> EOF

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# cat /boot/cmdline.txt 
console=serial0,115200 console=tty1 root=PARTUUID=3398887f-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

# TOKEN=$(sudo kubeadm token generate)
# echo $TOKEN
# apt-mark hold kubelet kubeadm kubectl

root@rpi00:~# kubeadm init --token=${TOKEN} --apiserver-advertise-address=192.168.21.40 --pod-network-cidr=10.244.0.0/16 -v 5
I0919 09:11:22.671184    1014 initconfiguration.go:103] detected and using CRI socket: /var/run/dockershim.sock
I0919 09:11:24.042601    1014 version.go:183] fetching Kubernetes version from URL: https://dl.k8s.io/release/stable-1.txt
W0919 09:11:24.778618    1014 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[init] Using Kubernetes version: v1.19.2
[preflight] Running pre-flight checks
...
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.21.40:6443 --token
...

# mkdir -p CNI
# wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O ~/CNI/kube-flannel.yml
# kubectl apply -f ~/CNI/kube-flannel.yml 
podsecuritypolicy.policy/psp.flannel.unprivileged created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
serviceaccount/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds-amd64 created
daemonset.apps/kube-flannel-ds-arm64 created
daemonset.apps/kube-flannel-ds-arm created
daemonset.apps/kube-flannel-ds-ppc64le created
daemonset.apps/kube-flannel-ds-s390x created

# edit /etc/kubernetes/manifests/kube-controller-manager.yaml

# diff -Nru kube-controller-manager.yaml.orig /etc/kubernetes/manifests/kube-controller-manager.yaml
--- kube-controller-manager.yaml.orig	2020-09-19 09:26:34.163904189 +0100
+++ /etc/kubernetes/manifests/kube-controller-manager.yaml	2020-09-19 09:18:24.068649122 +0100
@@ -30,6 +30,8 @@
     - --service-account-private-key-file=/etc/kubernetes/pki/sa.key
     - --service-cluster-ip-range=10.96.0.0/12
     - --use-service-account-credentials=true
+    - --allocate-node-cidrs=true
+    - --cluster-cidr=10.244.0.0/16
     image: k8s.gcr.io/kube-controller-manager:v1.19.2
     imagePullPolicy: IfNotPresent
     livenessProbe:
```
