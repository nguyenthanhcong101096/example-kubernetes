## PersistentVolume && PersistentVolumeClaim
**PersistentVolume**
- Là một phần không gian lưu trữ dữ liệu trong cluster
- Các PersistentVolume giống với Volume bình thường tuy nhiên nó tồn tại độc lập với POD (pod bị xóa PV vẫn tồn tại), có nhiều loại PersistentVolume có thể triển khai như NFS, Clusterfs ...

**PersistentVolumeClaim**
- Là yêu cầu sử dụng không gian lưu trữ (sử dụng PV).
- Hình dung PV giống như Node, PVC giống như POD. POD chạy nó sử dụng các tài nguyên của NODE, PVC hoạt động nó sử dụng tài nguyên của PV.

> Mỗi PV chỉ có 1 PVC

![](https://raw.githubusercontent.com/xuanthulabnet/learn-kubernetes/master/imgs/kubernetes056.jpg)

**Tạo Persistent Volume**
- Ví dụ này, sẽ tạo PV loại hostPath, tức ánh xạ một thư mục trên máy chạy POD. Tạo một manifest như sau:

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
spec:
  storageClassName: mystorageclass
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/v1"
```

```
ReadWriteOnce (RWO) -- the volume can be mounted as read-write by a single node
ReadOnlyMany (ROX) -- the volume can be mounted read-only by many nodes
ReadWriteMany (RWX) -- the volume can be mounted as read-write by many nodes
```

![](https://raw.githubusercontent.com/xuanthulabnet/learn-kubernetes/master/imgs/kubernetes034.png)

**Tạo Persistent Volume Claim**
- PVC (Persistent Volume Claim) là yêu cầu truy cập đến PV, một PV chỉ có một PVC

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc
  labels:
    name: pvc
spec:
  storageClassName: mystorageclass
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 150Mi
```

![](https://raw.githubusercontent.com/xuanthulabnet/learn-kubernetes/master/imgs/kubernetes035.png)

## Sử dụng PVC với Pod
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
  labels:
    name: deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      name: busybox
  template:
    metadata:
      name: busybox
      labels:
        name: busybox
    spec:
      volumes:
      - name: myvolume
        persistentVolumeClaim:
          claimName: vpc
      containers:
      - name: busybox
        image: busybox
        resources: {}
        ports:
          - containerPort: 80
        volumeMounts:
          - mountPath: "/data"
            name: myvolume
```

Gải thích:
- Tạo ra volumes presistent (PV)
- Tạo ra volumes presistent cliam (PVC). 1 PV -> 1 PVC, VPC sẽ request truy cập ổ đĩa tới PV
- Mount PVC vào POD trong Deployment

Tiến trình:
- PV 1 sẽ tạo ra 1 folder v1 trên VPS
- Sau đó PVC sẽ yêu cầu truy cập tới PV
- Sau đó trên POD sử dụng volumes là PVC mount tới /data trên container