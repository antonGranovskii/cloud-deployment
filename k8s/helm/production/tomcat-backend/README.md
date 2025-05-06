# Tomcat Backend Helm Chart

This Helm chart deploys the Tomcat-based backend application to a Kubernetes cluster.

## 📁 Directory Structure
```
tomcat-backend/
├── templates/
├── values.yaml
├── Chart.yaml
└── README.md
```


## Prerequisites

- Kubernetes cluster with Helm v3.x+
- Access to DockerHub or internal image registry

## Chart Details

- **Name**: `tomcat-backend`
- **App**: Java web application
- **Base Image**: `tomcat:9.0-jdk11`

## Installation

```bash
helm install tomcat-backend ./tomcat-backend -n production

```

## After deployment, access via:
```bash
kubectl get svc -n production tomcat-backend

URL: http://<tomcat-backend-lb-dns>
```

## Uninstall
```bash
helm uninstall tomcat-backend -n production
```