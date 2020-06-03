# raspberry-pi-arm64-kubernetes
Raspberry Pi arm64 Kubernetes Cluster

```
# dd if=2020-05-27-raspios-buster-arm64.img of=/dev/mmcblk0 bs=65536
# apt full-upgrade 

# systemctl stop dhcpcd5.service 
# systemctl disable dhcpcd5.service 
# systemctl stop dhcpcd.service 
# systemctl disable dhcpcd.service 

# systemctl disable NetworkManager.service 
# systemctl mask NetworkManager.service 
# systemctl status networking.service 
# systemctl restart networking.service 

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

# kubeadm init
W0601 20:52:01.595414     797 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
[init] Using Kubernetes version: v1.18.3
[preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
[preflight] Pulling images required for setting up a Kubernetes cluster
...
addons] Applied essential addon: CoreDNS
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
--- kube-controller-manager.yaml.orig   2020-06-01 21:18:29.953059853 +0100
+++ /etc/kubernetes/manifests/kube-controller-manager.yaml      2020-06-01 21:13:40.718620868 +0100
@@ -25,6 +25,8 @@
     - --root-ca-file=/etc/kubernetes/pki/ca.crt
     - --service-account-private-key-file=/etc/kubernetes/pki/sa.key
     - --use-service-account-credentials=true
+    - --allocate-node-cidrs=true
+    - --cluster-cidr=10.244.0.0/16
     image: k8s.gcr.io/kube-controller-manager:v1.18.3
     imagePullPolicy: IfNotPresent
     livenessProbe:
```
