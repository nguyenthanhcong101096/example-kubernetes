### Ví dụ ứng dụng Service, Deployment, Secret
Trong ví dụ này, sẽ thực hành triển khai chạy máy chủ nginx với mức độ áp dụng phức tạp hơn đó là:

- Xây dựng một image mới từ image cơ sở nginx rồi đưa lên registry Hub Docker đặt tên là `ichte/swarmtest:nginx`
- Tạo Secret chứa xác thực SSL sử dụng bởi `ichte/swarmtest:nginx`
- Tạo deployment chạy/quản lý các POD có chạy `ichte/swarmtest:nginx`
- Tạo Service kiểu NodePort để truy cập đến các POD trên

### Tự sinh xác thực với openssl

```
openssl req -nodes -newkey rsa:2048 -keyout tls.key  -out ca.csr -subj "/CN=xuanthulab.net"
openssl x509 -req -sha256 -days 365 -in ca.csr -signkey tls.key -out tls.crt
```

### Tạo Secret tên secret-nginx-cert chứa các xác thự
```
# Thi hành lệnh sau để tạo ra một Secret (loại ổ đĩa chứa các thông tin nhạy cảm, nhỏ), Secret này kiểu tls, tức chứa xác thức SSL
kubectl create secret tls secret-nginx-cert --cert=certs/tls.crt  --key=certs/tls.key

# Secret này tạo ra thì mặc định nó đặt tên file là tls.crt và tls.key có thể xem với lệnh
kubectl describe secret/secret-nginx-cert
```