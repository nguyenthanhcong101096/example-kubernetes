## VitrualBox
Fire up vms

``` 
vagrant up
```

To access each machine respectively via 
```
vagrant ssh [master|worker1|worker2]
```

in master node
```
# create cluster
kubeadm init --apiserver-advertise-address 192.168.33.13 --pod-network-cidr=10.244.0.0/16

# create network
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml

# create token join
kubeadm token create --print-join-command
```

in worker node
```
kubeadm join ....
```

in machince
```
# copy config file
scp root@172.16.10.100:/etc/kubernetes/admin.conf ~/.kube/config-mycluster

# set config file
export KUBECONFIG=/PATH/.kube/config-mycluster
```
