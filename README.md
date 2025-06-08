# IoTMining Technology

## Empowering the Future of IoT with Smart, Scalable, and Secure Solutions

---

### 🚀 About IoTMining

**IoTMining** is a cutting-edge, production-ready IoT Management Platform designed for managing millions of distributed edge devices securely and efficiently.

From **IoT gateways and NVRs** to **connected vehicles and smart energy systems**, IoTMining delivers robust features like multi-tenant device management, OTA updates, real-time telemetry, secure agent communication, and rich visual dashboards.

---

### 🧩 Key Capabilities

### 🧩 Key Features (Java Backend - IoTMining)

- ✅ **Multi-tenant Device Management**  
  Scalable and secure onboarding of IoT devices under hierarchical organization → company → user ownership with strict tenant isolation.
- 📡 **Real-Time Communication**  
  Supports MQTT (HiveMQ), Kafka event streams, and WebSocket push for live device telemetry and server notifications.

- 🔐 **Tenant-Based Access Control**  
  Fine-grained access with JWT authentication, tenant roles (`SUPER_ADMIN`, `TENANT_ADMIN`, `USER`) and device scoping.

- 📨 **Notification System**  
  Kafka and Flink-powered threshold monitoring with integration to WebSocket, MQTT, and future support for Email/SMS/Push.

- 🔄 **OTA Update Manager (Upcoming)**  
  Planned support for Over-the-Air updates to edge devices via manifest-controlled versions with rollback capabilities.

- 📁 **Cloud and Local Data Support**  
  Integration with MinIO for binary and video artifacts; PostgreSQL for structured metadata; optional InfluxDB for time-series.

- 📊 **Live Monitoring Dashboards (UI-Integrated)**  
  Backend APIs support dynamic, React-based dashboards with per-device telemetry, status indicators, and alert states.

- 🔍 **Audit Logging and Metrics**  
  All services include structured logging, user-action audit trails, and Prometheus/Zipkin tracing for observability.

- 🧩 **Modular Microservice Design**  
  All backend services (auth, device, tenant, notification, dashboard, OTA, file service, etc.) follow domain-driven design with Spring Boot.

- 📥 **REST & MQTT Integration APIs**  
  Uniform, well-documented APIs over REST for device control and configuration, plus bi-directional messaging over MQTT.

---

### 🏛️ Project Structure

```plaintext
iotmining/
├── agent/               # Lightweight Go-based agent for devices
├── microservices/       # Spring Boot services (auth, device, notification, etc.)
    ├── ai-engine
    ├── auth-service
    ├── data-factory-service
    ├── device-management-service
    ├── gateway
    ├── iot-protocol-notification
    ├── notification
    ├── tenant-management-service
├── dashboard-ui/        # React-based admin and monitoring frontend
├── infrastructure/      # Helm charts, K8s manifests, provisioning
├── configuration/       # Shared config files (Spring config server or k8s)
├── common/              # Shared libraries/utilities
    ├── base
    ├── data
    ├── interfaces
    ├── message
    ├── transport
    ├── utils
├── jenkins/             # CI/CD pipeline definitions
└── README.md            # You are here
├── setup.sh
```


# ⚙️ Getting Started with IoTMining

Follow these steps to clone the repository and set up the development environment.

---

## 📥 Clone the Repository

```bash
git clone https://github.com/IoTMining/iotmining.git
cd iotmining
```

---

## 🚀 Run Setup Script

Run the setup script to configure the environment:

```bash
bash setup.sh
```

You will be prompted with the following steps:

1. **Select authentication method**  
   Choose:
   ```
   1) PAT (Personal Access Token)
   ```

2. **Enter your GitHub PAT**  
   Paste your GitHub **Personal Access Token** when prompted.

3. **Select Environment**  
   Choose:
   ```
   dev
   ```

The script will automatically clone all necessary repositories and set up the local environment.

---

✅ You're now ready to start developing with **IoTMining**!