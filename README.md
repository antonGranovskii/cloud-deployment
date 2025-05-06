# EKS Production Environment Deployment with Terraform, Terragrunt, and Kubernetes

This guide describes how to deploy a production-ready Amazon EKS cluster using **Terraform** and **Terragrunt**, along with a basic monitoring setup and two demo applications:

- **Nginx** frontend (static site)
- **Tomcat** backend (Java app from DockerHub)
- **Grafana, Prometheus, Node-exporter, Cadvisor** for CPU and memory monitoring of the EKS cluster and Application Pods

---

## 📋 Prerequisites

Ensure the following tools are installed and configured:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2+
- [Terraform](https://developer.hashicorp.com/terraform/install) v1.11.0+
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) v0.75.0+
- [kubectl](https://kubernetes.io/docs/tasks/tools/) v1.33+
- [Helm](https://github.com/helm/helm/releases) v3.x+

---

## 📁 Project Structure
```
├── backend/
│   └── tomcat-backend/
├── frontend/
│   └── nginx-frontend/             
├── k8s/
│   └── helm/
│       ├── monitoring/          
│       └── production/              
├── terraform/
│   ├── infrastructure-live/         
│   ├── infrastructure-modules/      
│   └── aws-iam/                   
└── README.md

```

---

## 🚀 Deployment Guide

### 1. Create AWS USER and Configure AWS Credentials
1.1 You must have aws user to assume role required to run the terraform automation. Create it in AWS Console or take an existing one.
I suggest to create user "terraform".
1.2 Create AWS IAM Polcy "AllowTerraform"
```bash
# Use the custom json policy. Place you aws account id
terraform/aws-iam/1-AllowTerraform-policy.json
```
1.3 Create AWS Role "terraform" with Trust Relationships to allow sts:AssumeRole. Attach AdministratorAccess IAM Policy for simplicity to avoid missing permissions.
```bash
# Use the custom json trust policy. Place you aws account id
terraform/aws-iam/2-terraform-role-trust-policy.json
```
1.4 Create User Group `devops`. Add your user `terraform` and `AllowTerraform` Policy as a permission to Assume `terraform` role.

1.5 
Now you are ready to use the policy to run terraform




### 2. Deploy Infrastructure with Terragrunt
#### Assume created role and configure your session. This is required to bootstrap S3 and DynamoDB for tf.state and locks storage, to access the cluster and to deploy alb-controller as helm with terraform.
```
aws sts assume-role --role-arn arn:aws:iam::<your_aws_account_id>:role/terraform  --role-session-name terraform-session

export AWS_ACCESS_KEY_ID=your-access-key-id
export AWS_SECRET_ACCESS_KEY=your-secret-access-key
export AWS_SESSION_TOKEN=us-west-2  # change as needed
```
Specify your desired account ID in `terraform/infrastructure-live/accounts.json`

```bash
cd terraform/infrastructure-live

terragrunt run-all init
terragrunt run-all plan # Check what resources terraform is intending to create
terragrunt run-all apply # Apply deployment. Insert "y" to accept, "n" to deny
```
```bash
# NOTICE: Please come back to root path of the git repository
```

Terraform state will be stored in remote S3 backend:
```
s3 bucket name: hometask-prod-us-east-1-tf-state
```

Terraform Locks will be stored in  DynamoDB:
```
DynamoDB Name: hometask-prod-us-east-1-tf-locks
```
### 3. Configure Cluster Access

#### Add your user to auth config (Optional but recommended)
```
eksctl create iamidentitymapping \
  --cluster production \
  --region us-east-1 \
  --arn arn:aws:iam::<your_aws_account_id>:user/terraform \
  --username terraform \
  --group system:masters
```

#### Connect to the cluster
```
aws eks --region us-east-1 update-kubeconfig --name production
```


### 4. Deploy Monitoring Stack

#### Create namespace
```
kubectl apply -f k8s/helm/monitoring/namespace.yaml
```
#### Add helm repositories for grafana and prometheus
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

#### Install monitoring stack
```bash
# Prometheus
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --version 15.0.0 \
  -f k8s/helm/monitoring/prometheus/values.yaml
```
```bash
# Grafana
kubectl apply -f k8s/helm/monitoring/grafana/k8s/grafana-configmap.yaml # Grafana dashboards configured
helm install grafana grafana/grafana \
  --namespace monitoring \
  --version 8.2.0 \
  -f k8s/helm/monitoring/grafana/values.yaml
```
```bash
# cAdvisor
kubectl apply -f k8s/helm/monitoring/cadvisor/
```
```bash
# Check that all pods are up
kubectl get pods -n monitoring
```

### 5. Deploy Production Workload

#### Create production namespace
```
kubectl apply -f k8s/helm/production/namespace.yaml
```
#### Deploy Tomcat backend

```
helm install tomcat-backend k8s/helm/production/tomcat-backend -n production
```

#### NOTICE: Wait for tomcat to be ready before deploying frontend. Otherwise nginx pods will fail.

#### Deploy Nginx frontend
```
helm install nginx-frontend k8s/helm/production/nginx-frontend -n production
```
#### Check that all pods in production namespace are up
```
kubectl get pods -n production
```

### 6. Accessing Services
Run the commands below to get load-balancer dns name created by alb-controller.

#### Grafana
```
kubectl get svc -n monitoring grafana
```
#### Backend
```
kubectl get svc -n production tomcat-backend
```
#### Frontend
```
kubectl get svc -n production nginx-frontend
```

### Expected Outputs:
Now we can access our services in the internet by constructing URL from outputs above
```bash
Frontend URL: http://<nginx-frontend-lb-dns>
Backend  URL: http://<tomcat-backend-lb-dns>
Grafana  URL: http://<grafana-lb-dns>
```

### Accessing Monitoring Dashboards in Grafana

#### Get grafana password from k8s secret
```bash
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d

#### Log in
URL: http://<grafana-lb>/
Username: admin
Password: retrieved from the command above
```

Go to `Dashboards` tab after login, choose `Kubernetes` folder. There you will be able to see 2 dashboards:
1) Kubernetes CPU & Memory Usage # Shows the cluster's cpu and memory utilization
2) Production Pod CPU & Memory # Shows cpu and memory utilization of pods deployed to the production namespace: nginx-frontend and tomcat-backend




## Summary
With this setup, you’ve deployed:

  - A 2-node EKS production environment

  - A monitored Kubernetes cluster with Prometheus and Grafana

  - A demo Nginx frontend and Tomcat backend setup

  - Load-balanced access to all services




###  Cleanup
To destroy the infrastructure:
#### Uninstall helm monitoring stack
```bash
helm uninstall grafana -n monitoring
helm uninstall prometheus -n monitoring
```
#### Uninstall helm production workload
```bash
helm uninstall tomcat-backend -n production
helm uninstall nginx-frontend -n production
```

#### Destroy infrastructure deployed with Terraform
```bash
cd terraform/infrastructure-live
terragrunt run-all plan -destroy # Check that all the infrastructure can be destroyed
terragrunt run-all destroy # Destoy deployment. Insert "y" to accept, "n" to deny
```

#### Delete S3 bucket and DynamoDB
Go to AWS console and manualy remove s3 bucket created to store terraform state and delete dynamoDB used to store terraform lock to finish Clean UP the environment.





### Contact

Let me know if you want a version with any customizations.
