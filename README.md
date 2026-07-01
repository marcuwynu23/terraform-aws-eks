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

## Remote State Management (S3 Backend)

This module uses AWS S3 as the Terraform backend for remote state management with DynamoDB for state locking.

### Create the Backend Resources

Run the following commands once per AWS account to create the bucket and lock table:

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-southeast-1
```

### Configure the Backend

Create a `backend.tfvars` file:

```hcl
bucket         = "your-terraform-state-bucket"
key            = "eks/terraform.tfstate"
region         = "ap-southeast-1"
dynamodb_table = "terraform-state-lock"
encrypt        = true
```

Initialize with the backend config:

```bash
terraform init -backend-config="backend.tfvars"
```

### GitHub Actions CI/CD

Two workflows are available for automated deployment:

| Workflow | Description |
|----------|-------------|
| `terraform-cd-apply.yml` | Plan and provision infrastructure |
| `terraform-cd-destroy.yml` | Tear down infrastructure |

#### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key |
| `TF_STATE_BUCKET` | S3 bucket name for Terraform state |
| `TF_STATE_REGION` | AWS region for the state bucket |
| `TF_STATE_LOCK_TABLE` | DynamoDB table for state locking |

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
