# Prometheus Monitoring Stack (with Node Exporter)

## Prerequisites
Helm 3+ installed

A running Kubernetes cluster

monitoring namespace created

## Installation

#### Add prometheus-community helm repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

#### Install helm

```bash
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --version 15.0.0 \
  -f k8s/helm/monitoring/prometheus/values.yaml
```

## Helm Chart Info
### Component	Version
#### Helm Chart (Prometheus)	15.0.0
#### Node Exporter	included by default