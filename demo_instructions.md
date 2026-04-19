### 1. Web Frontend + load balancing (Port 8080)
- **Mở trình duyệt:** Truy cập `http://localhost:8080/` -> Hiển thị trang chủ thành công (HTTP 200).
- **Truy cập Blog:** Truy cập `http://localhost:8080/blog/` -> Hiển thị nội dung blog.
- Truy cập `http://localhost:8080/blog/` (hoặc qua port 80).
- Trình bày: Show trang Blog Index (có đánh dấu Server 1 hoặc Server 2). Click thử từ danh sách bài viết ở trang index vào từng bài cụ thể để chứng minh link hoạt động tốt và có chứa ảnh minh họa (ví dụ: ảnh Unsplash trong Blog 1).

### 2. App Backend (Port 8085 / 8081 nội bộ)
- **Kiểm tra trực tiếp:** Truy cập `http://localhost:8085/hello` -> Trả về JSON (ví dụ: `{"message": "Hello from backend"}`).
- **Kiểm tra qua API Gateway:** Truy cập `http://localhost/api/hello` -> Kết quả JSON tương tự.
- Truy cập `http://localhost:8085/student`.
- Trình bày: Show kết quả trả về danh sách 5 sinh viên (đọc từ file `students.json`).
### 3. Database (MariaDB / MySQL - Port 3306)
- **Mở Terminal**, truy cập vào container DB:
  ```bash
  docker exec -it relational-database-server mariadb -u root -p
  ```
  *(Nhập mật khẩu đã cấu hình trong docker-compose)* root admin
- **Chạy lệnh SQL:**
  ```sql
  SHOW DATABASES;
  USE minicloud;
  SELECT * FROM notes;
  ```
  -> Show ra bảng `notes` có sẵn dữ liệu.
- Trong Terminal (cửa sổ MariaDB ban nãy):
  ```sql
  USE studentdb;
  SELECT * FROM students;
  ```
  -> Show bảng gồm `id, student_id, fullname, dob, major` với ít nhất 3 bản ghi.
### 4. Auth / Identity (Keycloak - Port 8081)
- **Mở trình duyệt:** Truy cập `http://localhost:8081/` (hoặc qua Proxy: `http://localhost/auth/`)
- **Đăng nhập:** Vào Administration Console bằng tài khoản admin.
- **Tạo User (sv01):** Vào mục **Users** -> Nhấn **Add user** -> Điền username là `sv01` -> Chuyển sang tab Credentials, set password và tắt "Temporary".
- Trong Admin Console Keycloak:
  - Chọn Realm ở góc trái trên cùng -> Show Realm tên là **Mã Sinh Viên** (ví dụ `realm_sv001`).
  - Show 2 users đã tạo trong Realm đó.
  - Show Client có tên `flask-app` với cấu hình public.
- *(Tùy chọn nâng cao)* Dùng Postman hoặc CURL lấy token:
  ```bash
  curl -X POST "http://localhost:8081/realms/realm_sv001/protocol/openid-connect/token" \
       -H "Content-Type: application/x-www-form-urlencoded" \
       -d "username=<user>&password=<pass>&grant_type=password&client_id=flask-app"
  ```
  -> Trả về chuỗi JWT Token.

### 5. Object Storage (MinIO - Port 9000/9001)
- **Mở trình duyệt:** Truy cập `http://localhost:9001/` (hoặc Port UI bạn cấu hình).
- **Đăng nhập:** Bằng Access Key / Secret Key.
- **Tạo & Upload:** Nhấn **Create Bucket** tên `demo` -> Chọn bucket `demo` -> Nhấn **Upload File** và tải file `index.html` lên.
- Mở MinIO Console (`http://localhost:9001/`).
- Show 2 buckets `profile-pics` và `documents`.
- Upload ảnh avatar vào `profile-pics`, upload file PDF vào `documents`.
- Show cách lấy public URL (Share file) và dán sang tab ẩn danh để chứng minh có thể truy cập được.

### 6. Internal DNS (Bind9 - Port 1053 UDP) (where is this, is it on windows terminal or docker exex)
- **Mở Terminal**, chạy lệnh dig để phân giải tên miền:
  ```bash
  docker exec internal-dns-server dig @127.0.0.1 web-frontend-server.cloud.local +short
  ```
  -> Phải trả về IP nội bộ của web-frontend-server (ví dụ: `10.10.10.10`).
- Mở Terminal chạy 3 lệnh dig:
  ```bash
  docker exec internal-dns-server dig @127.0.0.1 app-backend.cloud.local +short
  docker exec internal-dns-server dig @127.0.0.1 application-backend-server.cloud.local +short
  docker exec internal-dns-server dig @127.0.0.1 minio.cloud.local +short
  docker exec internal-dns-server dig @127.0.0.1 keycloak.cloud.local +short
  ```
  -> Show kết quả trả về các IP nội bộ tương ứng.

### 7. Monitoring (Prometheus + Node Exporter - Port 9090)
- **Mở trình duyệt:** Truy cập `http://localhost:9090/`.
- **Kiểm tra Target:** Vào **Status -> Targets**, chỉ ra target node-exporter đang ở trạng thái **UP**.
- **Chạy Query:** Ở ô tìm kiếm, gõ `node_cpu_seconds_total` và nhấn **Execute**, chuyển sang tab **Graph** để xem biểu đồ.
- Mở Prometheus (`http://localhost:9090/`).
- Vào **Status -> Targets**, kéo xuống tìm job của web-frontend-server (port 80) và chứng minh nó đang ở trạng thái **UP**. Mở file `prometheus.yml` ra để giáo viên xem cấu hình.

### 8. Grafana (Port 3000)
- **Mở trình duyệt:** Truy cập `http://localhost:3000/`.
- **Kiểm tra Data Source:** Vào Connections -> Data sources -> Thấy Prometheus đã được kết nối.
- **Xem Dashboard:** Mở Dashboard "Node Exporter Full" (Dashboards -> Browse) -> Show các biểu đồ hoạt động.
- Vào Grafana (`http://localhost:3000/`).
- Mở Dashboard có tên **"System Health of [Tên SV]"**.
- Show 3 biểu đồ đã vẽ: **CPU Usage**, **Memory Usage**, và **Network Traffic**.
### 9. API Gateway / Proxy (Nginx - Port 80)
- **Mở trình duyệt** (đã test một phần ở trên, giờ tổng hợp lại):
  - Truy cập `http://localhost/` -> Trả về Web Frontend.
  - Truy cập `http://localhost/api/hello` -> Trả về Backend JSON.
  - Truy cập `http://localhost/auth/` -> Trả về giao diện Keycloak.
- Truy cập trình duyệt hoặc Postman: `http://localhost/student/` (hoặc `http://localhost/api/student`).
- Show ra kết quả giống hệt khi gọi qua port 8085 trực tiếp.

ping 
docker exec internal-dns-server ping -c 3 web-frontend-server-1
docker exec internal-dns-server ping -c 3 application-backend-server
docker exec internal-dns-server ping -c 3 relational-database-server
docker exec internal-dns-server ping -c 3 authentication-identity-server
docker exec internal-dns-server ping -c 3 object-storage-server
docker exec internal-dns-server ping -c 3 monitoring-prometheus-server
docker exec internal-dns-server ping -c 3 monitoring-grafana-dashboard-server


---
To demo this project on AWS, you need to launch a Virtual Machine (EC2 instance), install Docker, transfer your code, and open the firewall ports so your teacher can access it from the internet instead of just your local computer.

Since you successfully commented out the memory limits for your local run and restored Docker, here are the exact steps to deploy it to AWS for the real demo:


### Step 1: Connect to the Server & Install Docker
1. SSH into your server using the `.pem` key you downloaded:


ssh -i "F:\new shit\cloud-key.pem" ubuntu@54.206.106.33
```

### Step 5: Transfer Your Code to AWS
You can easily upload your project folder to the EC2 instance using `scp` from your Windows terminal:
*(Note: Don't upload the `.git` or local database data folders if they are huge)*
```powershell
scp -r -i \path\to\cloud-key.pem "f:\n3hk2\CLoud Computing\cloud-computing-ck" ubuntu@<YOUR_EC2_PUBLIC_IP>:/home/ubuntu/
```
*(Alternatively, you can just push your code to a private GitHub repository and `git clone` it directly inside the EC2 instance).*

### Step 6: Uncomment Memory Limits & Start the Cloud
1. In the EC2 terminal, go to your project folder:
   ```bash
   cd cloud-computing-ck
   ```
2. **Important:** Since you are now on a 1GB AWS instance, you need to open `docker-compose.yaml` (using `nano docker-compose.yaml`) and **uncomment** all those `deploy: resources: limits: memory:` lines you just commented out locally!
3. Build and run everything:
   ```bash
   docker-compose build
   docker-compose up -d
   ```

### Step 7: Do the Demo!
Now, instead of using `localhost`, you just use your AWS EC2 Public IP address for the demo.
- Load Balancer: `http://<EC2_PUBLIC_IP>/`
- Grafana: `http://<EC2_PUBLIC_IP>:3000/`
- MinIO: `http://<EC2_PUBLIC_IP>:9001/`

*(Everything will behave exactly as it did locally!)*