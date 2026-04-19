# Cloud Demo Instructions

## 1. Web Frontend + Load Balancing (Port 8080)

- **Mo trinh duyet:** Truy cap `http://localhost:8080/` -> Hien thi trang chu thanh cong (HTTP 200).
- **Truy cap Blog:** Truy cap `http://localhost:8080/blog/` -> Hien thi noi dung blog.
- Truy cap `http://localhost:8080/blog/` (hoac qua port 80).
- Trinh bay: Show trang Blog Index (co danh dau Server 1 hoac Server 2). Click thu tu danh sach bai viet o trang index vao tung bai cu the de chung minh link hoat dong tot va co chua anh minh hoa (vi du: anh Unsplash trong Blog 1).

## 2. App Backend (Port 8085 / 8081 noi bo)

- **Kiem tra truc tiep:** Truy cap `http://localhost:8085/hello` -> Tra ve JSON (vi du: `{"message": "Hello from backend"}`).
- **Kiem tra qua API Gateway:** Truy cap `http://localhost/api/hello` -> Ket qua JSON tuong tu.
- Truy cap `http://localhost:8085/student`.
- Trinh bay: Show ket qua tra ve danh sach 5 sinh vien (doc tu file `students.json`).

## 3. Database (MariaDB / MySQL - Port 3306)

- **Mo Terminal**, truy cap vao container DB:

```bash
docker exec -it relational-database-server mariadb -u root -p
```

(Nhap mat khau da cau hinh trong docker-compose) root admin.

- **Chay lenh SQL:**

```sql
SHOW DATABASES;
USE minicloud;
SELECT * FROM notes;
```

-> Show ra bang `notes` co san du lieu.

- Trong Terminal (cua so MariaDB ban nay):

```sql
USE studentdb;
SELECT * FROM students;
```

-> Show bang gom `id, student_id, fullname, dob, major` voi it nhat 3 ban ghi.

## 4. Auth / Identity (Keycloak - Port 8081)

- **Mo trinh duyet:** Truy cap `http://localhost:8081/` (hoac qua Proxy: `http://localhost/auth/`).
- **Dang nhap:** Vao Administration Console bang tai khoan admin.
- **Tao User (sv01):** Vao muc **Users** -> Nhan **Add user** -> Dien username la `sv01` -> Chuyen sang tab Credentials, set password va tat "Temporary".
- Trong Admin Console Keycloak:
  - Chon Realm o goc trai tren cung -> Show Realm ten la **Ma Sinh Vien** (vi du `realm_sv001`).
  - Show 2 users da tao trong Realm do.
  - Show Client co ten `flask-app` voi cau hinh public.
- (Tuy chon nang cao) Dung Postman hoac CURL lay token:

```bash
curl -X POST "http://localhost:8081/realms/realm_sv001/protocol/openid-connect/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "username=<user>&password=<pass>&grant_type=password&client_id=flask-app"
```

-> Tra ve chuoi JWT Token.

## 5. Object Storage (MinIO - Port 9000/9001)

- **Mo trinh duyet:** Truy cap `http://localhost:9001/` (hoac Port UI ban cau hinh).
- **Dang nhap:** Bang Access Key / Secret Key.
- **Tao va Upload:** Nhan **Create Bucket** ten `demo` -> Chon bucket `demo` -> Nhan **Upload File** va tai file `index.html` len.
- Mo MinIO Console (`http://localhost:9001/`).
- Show 2 buckets `profile-pics` va `documents`.
- Upload anh avatar vao `profile-pics`, upload file PDF vao `documents`.
- Show cach lay public URL (Share file) va dan sang tab an danh de chung minh co the truy cap duoc.

## 6. Internal DNS (Bind9 - Port 1053 UDP)

- **Mo Terminal**, chay lenh dig de phan giai ten mien:

```bash
docker exec internal-dns-server dig @127.0.0.1 web-frontend-server.cloud.local +short
```

-> Phai tra ve IP noi bo cua web-frontend-server (vi du: `10.10.10.10`).

- Mo Terminal chay cac lenh dig:

```bash
docker exec internal-dns-server dig @127.0.0.1 app-backend.cloud.local +short
docker exec internal-dns-server dig @127.0.0.1 application-backend-server.cloud.local +short
docker exec internal-dns-server dig @127.0.0.1 minio.cloud.local +short
docker exec internal-dns-server dig @127.0.0.1 keycloak.cloud.local +short
```

-> Show ket qua tra ve cac IP noi bo tuong ung.

## 7. Monitoring (Prometheus + Node Exporter - Port 9090)

- **Mo trinh duyet:** Truy cap `http://localhost:9090/`.
- **Kiem tra Target:** Vao **Status -> Targets**, chi ra target node-exporter dang o trang thai **UP**.
- **Chay Query:** O o tim kiem, go `node_cpu_seconds_total` va nhan **Execute**, chuyen sang tab **Graph** de xem bieu do.
- Mo Prometheus (`http://localhost:9090/`).
- Vao **Status -> Targets**, keo xuong tim job cua web-frontend-server (port 80) va chung minh no dang o trang thai **UP**. Mo file `prometheus.yml` ra de giao vien xem cau hinh.

## 8. Grafana (Port 3000)

- **Mo trinh duyet:** Truy cap `http://localhost:3000/`.
- **Kiem tra Data Source:** Vao Connections -> Data sources -> Thay Prometheus da duoc ket noi.
- **Xem Dashboard:** Mo Dashboard "Node Exporter Full" (Dashboards -> Browse) -> Show cac bieu do hoat dong.
- Vao Grafana (`http://localhost:3000/`).
- Mo Dashboard co ten **"System Health of [Ten SV]"**.
- Show 3 bieu do da ve: **CPU Usage**, **Memory Usage**, va **Network Traffic**.

## 9. API Gateway / Proxy (Nginx - Port 80)

- **Mo trinh duyet** (da test mot phan o tren, gio tong hop lai):
  - Truy cap `http://localhost/` -> Tra ve Web Frontend.
  - Truy cap `http://localhost/api/hello` -> Tra ve Backend JSON.
  - Truy cap `http://localhost/auth/` -> Tra ve giao dien Keycloak.
- Truy cap trinh duyet hoac Postman: `http://localhost/student/` (hoac `http://localhost/api/student`).
- Show ra ket qua giong het khi goi qua port 8085 truc tiep.

### Ping Connectivity Checks

```bash
docker exec internal-dns-server ping -c 3 web-frontend-server-1
docker exec internal-dns-server ping -c 3 application-backend-server
docker exec internal-dns-server ping -c 3 relational-database-server
docker exec internal-dns-server ping -c 3 authentication-identity-server
docker exec internal-dns-server ping -c 3 object-storage-server
docker exec internal-dns-server ping -c 3 monitoring-prometheus-server
docker exec internal-dns-server ping -c 3 monitoring-grafana-dashboard-server
```

---

## AWS Demo Deployment

To demo this project on AWS, launch an EC2 instance, install Docker, transfer your code, and open required firewall ports so your teacher can access it from the internet.

Since you already commented out memory limits for local run and restored Docker, follow these steps for deployment:

### Step 1: Connect to the Server and Install Docker

1. SSH into your server using the `.pem` key you downloaded:

```bash
ssh -i "F:\new shit\cloud-key.pem" ubuntu@54.206.106.33
```

### Step 5: Transfer Your Code to AWS

You can upload your project folder to EC2 using `scp` from Windows terminal.

(Note: Do not upload `.git` or large local data folders.)

```powershell
scp -r -i \path\to\cloud-key.pem "f:\n3hk2\CLoud Computing\cloud-computing-ck" ubuntu@<YOUR_EC2_PUBLIC_IP>:/home/ubuntu/
```

(Alternatively, push to a private GitHub repository and run `git clone` on EC2.)

### Step 6: Uncomment Memory Limits and Start the Cloud

- In the EC2 terminal, go to your project folder:

```bash
cd cloud-computing-ck
```

- **Important:** On a 1GB AWS instance, open `docker-compose.yaml` (for example, `nano docker-compose.yaml`) and uncomment all `deploy: resources: limits: memory:` lines.
- Build and run everything:

```bash
docker-compose build
docker-compose up -d
```

### Step 7: Do the Demo

Now use your EC2 Public IP instead of `localhost`:

- Load Balancer: `http://<EC2_PUBLIC_IP>/`
- Grafana: `http://<EC2_PUBLIC_IP>:3000/`
- MinIO: `http://<EC2_PUBLIC_IP>:9001/`

(Everything should behave the same as local run.)
