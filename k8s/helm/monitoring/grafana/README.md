# Grafana Installation via Helm

This guide provides instructions to install and upgrade Grafana using Helm in a Kubernetes cluster.

## Prerequisites
Helm 3+ installed

A running Kubernetes cluster

monitoring namespace created


## Installation

#### Add prometheus-community helm repository
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

#### Install helm

```bash
helm install grafana grafana/grafana \
  --namespace monitoring \
  -f k8s/helm/monitoring/grafana/values.yaml
```

## After deployment, access via:
```bash
kubectl get svc -n monitoring grafana

URL: http://<grafana-lb-dns>
```


## Helm Chart Info
### Component	Version
#### Helm Chart	8.2.0
#### Grafana	11.0.0