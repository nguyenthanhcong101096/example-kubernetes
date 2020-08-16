### Volumes
- Là thành phần trực thuộc Pods. ***Volumes*** được định nghĩa trong cấu hình file yaml khi khởi tạo các Pods. Các container có thể thực hiện mount dữ liệu bên trong container đến đối tượng ***volumes*** thuộc cùng Pods.

![](https://cuongquach.com/resources/images/2020/03/emptydir-hostpath-kubernetes-volume-1.jpg)

#### Các loại volumes:
- emptyDir
- hostPath
- ConfigMap & secret
- persistentVolumeClaim
- PersistentVolume

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

#### 4 PersistentVolume
- Là một phần không gian lưu trữ dữ liệu tronnng cluster
- Các PersistentVolume giống với Volume bình thường tuy nhiên nó tồn tại độc lập với POD (pod bị xóa PV vẫn tồn tại), có nhiều loại PersistentVolume có thể triển khai như NFS, Clusterfs ...