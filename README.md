# Terraform AWS EKS Cluster Provisioning

This Terraform project provisions a fully functional Amazon EKS (Elastic Kubernetes Service) cluster, including networking, IAM roles, and managed node groups.

---

## Overview

This configuration creates:

- A custom VPC
- Public subnets across multiple availability zones
- An EKS control plane (cluster)
- Managed node group (worker nodes)
- IAM roles for cluster and nodes
- Kubernetes provider configuration

---

## Resources Created

- `aws_vpc.eks_vpc` – VPC for EKS cluster
- `aws_subnet.eks_subnet` – Public subnets (multi-AZ)
- `aws_eks_cluster.eks_cluster` – EKS control plane
- `aws_eks_node_group.eks_nodes` – Worker nodes
- `aws_iam_role.eks_cluster_role` – IAM role for EKS cluster
- `aws_iam_role.eks_node_role` – IAM role for worker nodes
- IAM policy attachments for cluster and nodes

---

## Prerequisites

Ensure the following are installed and configured:

- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- kubectl
- AWS IAM permissions for EKS, EC2, IAM, and VPC

Verify:

```sh
terraform -v
aws sts get-caller-identity
kubectl version --client
```

---

## File Structure

```
.
├── main.tf
└── README.md
```

---

## Architecture

- VPC CIDR: 10.0.0.0/16
- Subnets: 2 public subnets (multi-AZ)
- Node Group: 3 nodes (t3.medium)
- Cluster Name: demo-eks-cluster

---

## Usage

### 1. Initialize Terraform

```sh
terraform init
```

---

### 2. Validate Configuration

```sh
terraform validate
```

---

### 3. Plan Deployment

```sh
terraform plan
```

---

### 4. Apply Infrastructure

```sh
terraform apply -auto-approve
```

This will provision:

- VPC and subnets
- IAM roles and policies
- EKS cluster
- Node group

Note: EKS provisioning may take 10–15 minutes.

---

### 5. Configure kubectl Access

After deployment, configure access to your cluster:

```sh
aws eks --region ap-southeast-1 update-kubeconfig --name demo-eks-cluster
```

Verify connection:

```sh
kubectl get nodes
```

---

### 6. Destroy Infrastructure (optional)

```sh
terraform destroy -auto-approve
```

---

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "eks_cluster" {
  source = "github.com/marcuwynu23/terraform-aws-eks?ref=main"
}
```

After deployment, configure kubectl access:

```sh
aws eks --region ap-southeast-1 update-kubeconfig --name demo-eks-cluster
```

---

## Kubernetes Provider

Terraform automatically configures the Kubernetes provider using:

- EKS cluster endpoint
- Cluster certificate
- Authentication token

This allows Terraform to manage Kubernetes resources if added later.

---

## Node Group Configuration

- Instance Type: t3.medium
- Desired Size: 3
- Min Size: 3
- Max Size: 3

---

## Networking

- Public subnets with auto-assign public IP
- Multi-AZ deployment (ap-southeast-1a, ap-southeast-1b)

---

## Security & IAM

Cluster Role:

- AmazonEKSClusterPolicy

Node Role:

- AmazonEKSWorkerNodePolicy
- AmazonEC2ContainerRegistryReadOnly
- AmazonEKS_CNI_Policy

---

## Common Issues

### kubectl cannot connect

- Ensure kubeconfig is updated
- Check IAM permissions

### Nodes not joining cluster

- Verify node IAM role policies
- Check subnet networking and routing

### Cluster creation fails

- Ensure region supports EKS
- Check service quotas

---

## Best Practices

- Use private subnets for production workloads
- Add NAT Gateway for outbound traffic
- Enable cluster logging
- Use autoscaling node groups
- Integrate with IAM roles for service accounts (IRSA)

---

## Summary

This Terraform setup provides a minimal EKS cluster with:

- Managed Kubernetes control plane
- Scalable worker nodes
- Basic networking setup
- Ready-to-use kubectl access

Extend this by adding:

- Ingress controllers
- Helm deployments
- CI/CD pipelines
- Monitoring (Prometheus/Grafana)
