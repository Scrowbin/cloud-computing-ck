# cloud-computing-ck

Mini cloud demo with 9 services on a shared `cloud-net` network.

## Services

- Web Frontend Server: `http://localhost:8080/`
- Application Backend Server: `http://localhost:8085/hello`
- Relational Database Server: `localhost:3306`
- Authentication Identity Server: `http://localhost:8081/`
- Object Storage Server: `http://localhost:9001/`
- Internal DNS Server: `127.0.0.1:1053`
- Monitoring Prometheus Server: `http://localhost:9090/`
- Monitoring Grafana Dashboard Server: `http://localhost:3000/`
- API Gateway Proxy Server: `http://localhost/`

## Demo Checks

- Web Frontend Server: `/` and `/blog/`
- Application Backend Server: `/hello` and `/api/hello`
- Relational Database Server: `minicloud.notes`
- Authentication Identity Server: Keycloak admin login
- Object Storage Server: MinIO console login
- Internal DNS Server: `web-frontend-server.cloud.local`
- Monitoring Prometheus Server: target `monitoring-node-exporter-server:9100`
- Monitoring Grafana Dashboard Server: `System Health` dashboard
- API Gateway Proxy Server: `/`, `/api/hello`, `/auth/`
