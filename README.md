# Terraform AWS EKS Cluster Provisioning

This Terraform project provisions a fully functional Amazon EKS (Elastic Kubernetes Service) cluster, including networking, IAM roles, and managed node groups.

## Prerequisites

Ensure the following are installed and configured:
- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- kubectl
- AWS IAM permissions for EKS, EC2, IAM, and VPC

Verify:

```bash
aws sts get-caller-identity
kubectl version --client
```

## Setup & Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Plan Deployment**:
   ```bash
   terraform plan
   ```

4. **Apply Infrastructure** (provisioning may take 10–15 minutes):
   ```bash
   terraform apply -auto-approve
   ```

5. **Configure kubectl Access**:
   ```bash
   aws eks --region ap-southeast-1 update-kubeconfig --name demo-eks-cluster
   kubectl get nodes
   ```

6. **Destroy** (when no longer needed):
   ```bash
   terraform destroy -auto-approve
   ```

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "eks_cluster" {
  source = "github.com/marcuwynu23/terraform-aws-eks?ref=main"
}
```

After deployment, configure kubectl access as shown above.

## Variables

This module accepts no configurable variables. All resource names and settings are preconfigured with sensible defaults.

## Resources Created

- `aws_vpc.eks_vpc` – VPC for EKS cluster
- `aws_subnet.eks_subnet` – Public subnets (multi-AZ)
- `aws_eks_cluster.eks_cluster` – EKS control plane
- `aws_eks_node_group.eks_nodes` – Worker nodes (t3.medium, 3 nodes)
- `aws_iam_role.eks_cluster_role` – IAM role for EKS cluster
- `aws_iam_role.eks_node_role` – IAM role for worker nodes

## Node Group Configuration

- Instance Type: t3.medium
- Desired Size: 3 | Min Size: 3 | Max Size: 3

## Networking

- VPC CIDR: 10.0.0.0/16
- 2 public subnets (ap-southeast-1a, ap-southeast-1b) with auto-assign public IP

## Security & IAM

Cluster Role: AmazonEKSClusterPolicy
Node Role: AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy

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
