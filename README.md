# raspberry-pi-arm64-kubernetes
Raspberry Pi arm64 Kubernetes Cluster

```
    dd if=2020-05-27-raspios-buster-arm64.img of=/dev/mmcblk0 bs=65536
    apt full-upgrade 

    systemctl stop dhcpcd5.service 
    systemctl disable dhcpcd5.service 
    systemctl stop dhcpcd.service 
    systemctl disable dhcpcd.service 

    systemctl disable NetworkManager.service 
    systemctl mask NetworkManager.service 
    systemctl status networking.service 
    systemctl restart networking.service 

    ifup eth0
```
