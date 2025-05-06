# Nginx Frontend Helm Chart

This Helm chart deploys the nginx-based frontend application to a Kubernetes cluster.

## 📁 Directory Structure
```
nginx-frontend/
├── templates/
├── values.yaml
├── Chart.yaml
└── README.md
```


## Prerequisites

- Kubernetes cluster with Helm v3.x+
- Access to DockerHub or internal image registry

## Chart Details

- **Name**: `nginx-frontend`
- **App**: Nginx Reverse Proxy
- **Base Image**: `nginx:1.21-alpine`

## Installation

```bash
helm install nginx-frontend ./nginx-frontend -n production

```

## After deployment, access via:
```bash
kubectl get svc -n production nginx-frontend

URL: http://<nginx-frontend-lb-dns>
```

## Uninstall
```bash
helm uninstall nginx-frontend -n production
```