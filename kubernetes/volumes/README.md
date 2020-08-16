### Volumes
- Là thành phần trực thuộc Pods. ***Volumes*** được định nghĩa trong cấu hình file yaml khi khởi tạo các Pods. Các container có thể thực hiện mount dữ liệu bên trong container đến đối tượng ***volumes*** thuộc cùng Pods.

![](https://cuongquach.com/resources/images/2020/03/emptydir-hostpath-kubernetes-volume-1.jpg)

#### Các loại volumes:
- emptyDir
- hostPath
- ConfigMap & secret
- PersistentVolume && persistentVolumeClaim

#### 1. emptyDir
- Là dạng volume được tạo ra khi 1 Pod được gán vào 1 node, tồn tại trong suốt quá trình Pod chạy trên node.
- Khi Pod bị xóa khỏi node, dữ liệu trong emptyDir sẽ bị xóa.
- Container bị crashing, dữ liệu không bị mất.
- emptyDir lưu trữ trên thư mục `/var/lib/kubelet` của host.

```
apiVersion: v1
kind: Pod
metadata:
  name: emptydir
spec:
  containers:
  - image: nginx
    name: nginx
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir: {}
```

#### 2. hostPath
- Là dạng volume sẽ mount file or thư mục trên máy host vào pod. Tương tự docker.
- Dữ liệu được lưu trong volumes sẽ không bị mất khi Pods bị lỗi vì nó vốn được nằm ngoài Pods
- Khi Pods mới được tạo thành để thay thế Pods cũ, nó sẽ mount đến hostPath volume để làm việc tiếp với các dữ liệu ở Pods cũ.

![](https://images.viblo.asia/26c81744-115e-4d1d-a7ae-a74c305ba83b.png)

```
apiVersion: v1
kind: Pod
metadata:
  name: vol
  labels:
    app: app4
    ungdung: ungdung4
spec:
  # chay pod tren node minh muon
  nodeSelector:
    labels: ten label cua node
  volumes:
    # Dinh nghia volume anh xa thu muc /home/www may host
    - name: "host_path"
      hostPath:
        path: "/Users/mac/demo"
  containers:
  - name: nginx
    image: nginx:1.17.6
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 80
    volumeMounts:
      - mountPath: /usr/share/nginx/html
        name: "host_path"
```

#### 3. ConfigMap và Secret
- Trong hệ thống Kubernetes, Config Map và Secret là 2 loại volumes giúp lưu trữ biến môi trường để dùng cho các container thuộc các Pods khác nhau
- Thông thường khi lập trình các ứng dụng, chúng ta đều cho các biến quan trọng như `password url DB, secret key`, tên DB vào file `.env`

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-config-env-file
data:
  rails_env: production
  allowed: '"true"'
  port: "3000"
```

```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
```

![](https://images.viblo.asia/2880276d-517f-4a63-b9c2-eada5a54a469.png)

#### 4 PersistentVolume && PersistentVolumeClaim
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

**Sử dụng PVC với Pod**
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
