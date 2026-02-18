# 3-Tier Web Application

A modern 3-tier web application built with React frontend, Node.js/Express backend, and MySQL database, deployed on AWS using ECS, RDS, and Application Load Balancer.

## Project Overview

This project consists of three main components:

1. **Frontend**: React-based single-page application for user interface
2. **Backend**: Node.js/Express REST API server
3. **Database**: MySQL database hosted on AWS RDS

### Architecture

```
Internet → ALB (Port 80) → ECS Fargate (Port 3000) → RDS MySQL (Port 3306)
```

- **Frontend**: React app (static files)
- **Backend**: Containerized Node.js API running on ECS Fargate
- **Database**: MySQL 8.0 on RDS
- **Load Balancer**: Application Load Balancer for high availability
- **Networking**: VPC with public and private subnets, NAT Gateway

## Prerequisites

Before deploying, ensure you have the following installed:

- **AWS CLI** - [Install Guide](https://aws.amazon.com/cli/)
- **Terraform** (>= 1.0) - [Install Guide](https://www.terraform.io/downloads)
- **Docker** - [Install Guide](https://docs.docker.com/get-docker/)
- **Node.js** (>= 18) and npm - [Install Guide](https://nodejs.org/)
- **AWS Account** with appropriate permissions
- **AWS CLI configured** with credentials (`aws configure`)

## Pre-Deployment Steps

### 1. Build and Push Backend Docker Image to ECR

The backend needs to be containerized and pushed to Amazon ECR before Terraform deployment.

#### Step 1.1: Create ECR Repository (if not exists)

```bash
aws ecr create-repository \
    --repository-name backend-api \
    --region us-east-1
```

#### Step 1.2: Authenticate Docker to ECR

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

Replace `<AWS_ACCOUNT_ID>` with your AWS account ID (e.g., `302263055592`).

#### Step 1.3: Build Docker Image

```bash
cd backend
docker build -t backend-api .
```

#### Step 1.4: Tag and Push Image to ECR

```bash
# Tag the image
docker tag backend-api:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-api:latest

# Push to ECR
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-api:latest
```

**Important**: Update `terraform/terraform.tfvars` with your ECR repository URL:
```hcl
ecr_repo_url = "<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-api"
```

### 2. Build Frontend (Optional - for static hosting)

If you plan to host the frontend separately (e.g., S3 + CloudFront), build it:

```bash
cd frontend
npm install
npm run build
```

The `build/` folder will contain the production-ready static files.

**Note**: Currently, the frontend is not deployed via Terraform. You can:
- Deploy to S3 + CloudFront
- Deploy to a separate hosting service
- Serve from a CDN

## Terraform Deployment Steps

### Step 1: Configure Terraform Variables

Edit `terraform/terraform.tfvars` with your values:

```hcl
region = "us-east-1"

# Your ECR repository URL
ecr_repo_url = "<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-api"

# Project tags
tags = {
  Project = "3-tier-app"
  Env     = "dev"
}

project = "my-app"

# Database credentials (use strong passwords in production!)
DB_NAME = "mydb"
DB_USER = "admin"
DB_PASS = "YourStrongPassword123"
DB_HOST = ""  # Will be populated after RDS is created

# ALB DNS (will be populated after deployment)
alb_dns_name = ""
```

### Step 2: Initialize Terraform

```bash
cd terraform
terraform init
```

### Step 3: Review Terraform Plan

```bash
terraform plan
```

Review the plan to see what resources will be created:
- VPC with public and private subnets
- NAT Gateway
- Security Groups (ALB, ECS, RDS)
- RDS MySQL instance
- ECS Cluster and Service
- Application Load Balancer

### Step 4: Apply Terraform Configuration

```bash
terraform apply
```

Type `yes` when prompted. This will create all AWS resources.

**Deployment time**: Approximately 10-15 minutes (RDS takes the longest).

### Step 5: Get Outputs

After deployment completes, get the important outputs:

```bash
# Get ALB DNS name
terraform output alb_dns_name

# Get RDS endpoint
terraform output rds_endpoint
```

### Step 6: Update Configuration

1. **Update `terraform.tfvars`** with the RDS endpoint:
   ```hcl
   DB_HOST = "<rds-endpoint-from-output>"
   ```

2. **Update backend environment** (if needed):
   - The backend container will use environment variables from ECS task definition
   - These are set in `terraform/ecs.tf`

3. **Update frontend API URL**:
   - Edit `frontend/src/api.js` or set `REACT_APP_API_URL` environment variable
   - Point it to your ALB DNS name: `http://<alb-dns-name>`

### Step 7: Rebuild and Redeploy Backend (if DB_HOST changed)

If you updated the database host, rebuild and push the backend:

```bash
cd backend
docker build -t backend-api .
docker tag backend-api:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-api:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-api:latest
```

Then force a new ECS deployment:

```bash
aws ecs update-service \
    --cluster my-cluster \
    --service backend-api \
    --force-new-deployment \
    --region us-east-1
```

## Post-Deployment Verification

### 1. Test Backend API

```bash
# Health check
curl http://<alb-dns-name>/

# Should return: {"message":"Backend is working"}
```

### 2. Initialize Database

```bash
# Initialize messages table
curl -X POST http://<alb-dns-name>/init
```

### 3. Test API Endpoints

```bash
# Create a message
curl -X POST http://<alb-dns-name>/api/messages \
  -H "Content-Type: application/json" \
  -d '{"text":"Hello from API!"}'

# Get all messages
curl http://<alb-dns-name>/api/messages
```

### 4. Access Frontend

- If frontend is deployed separately, access it via its URL
- Make sure `REACT_APP_API_URL` points to your ALB DNS name

## Project Structure

```
3-tier-web_app/
├── backend/              # Node.js/Express API
│   ├── Dockerfile       # Container definition
│   ├── server.js        # Main server file
│   ├── db.js           # Database connection
│   └── package.json
├── frontend/            # React application
│   ├── src/
│   │   ├── App.js      # Main component
│   │   ├── api.js      # API client
│   │   └── index.js
│   └── package.json
└── terraform/           # Infrastructure as Code
    ├── modules/        # Terraform modules
    │   ├── vpc/        # VPC module
    │   ├── ecs/        # ECS module
    │   ├── rds/        # RDS module
    │   ├── alb/        # ALB module
    │   └── security_groups/  # Security groups
    ├── vpc.tf          # VPC configuration
    ├── ecs.tf          # ECS configuration
    ├── rds.tf          # RDS configuration
    ├── alb.tf          # ALB configuration
    ├── variables.tf    # Variable definitions
    └── terraform.tfvars  # Variable values
```

## Port Configuration

- **Backend**: Port 3000 (container)
- **ALB Listener**: Port 80 (HTTP)
- **ALB Target Group**: Port 3000 (forwards to ECS)
- **RDS MySQL**: Port 3306

## Security Notes

⚠️ **Important Security Considerations**:

1. **Never commit sensitive data**:
   - `terraform.tfvars` contains sensitive values (already in `.gitignore`)
   - Use AWS Secrets Manager or Parameter Store for production

2. **Database Security**:
   - RDS is in private subnets (not publicly accessible)
   - Only accessible from ECS security group

3. **Network Security**:
   - ALB in public subnets (internet-facing)
   - ECS tasks in private subnets
   - NAT Gateway for outbound internet access

4. **IAM Permissions**:
   - Ensure Terraform has necessary permissions
   - Use least privilege principle

## Troubleshooting

### ECS Tasks Not Starting

```bash
# Check ECS service events
aws ecs describe-services \
    --cluster my-cluster \
    --services backend-api \
    --region us-east-1

# Check CloudWatch logs
aws logs tail /ecs/my-backend --follow --region us-east-1
```

### Database Connection Issues

- Verify RDS security group allows traffic from ECS security group on port 3306
- Check RDS endpoint is correct in environment variables
- Verify database credentials

### ALB Health Checks Failing

- Ensure backend is listening on port 3000
- Check security group rules
- Verify target group health check path is `/`

## Cleanup

To destroy all resources and avoid charges:

```bash
cd terraform
terraform destroy
```

**Warning**: This will delete all resources including the RDS database and all data!

## Cost Estimation

Approximate monthly costs (us-east-1):
- **RDS db.t3.micro**: ~$15/month
- **ECS Fargate** (0.25 vCPU, 0.5GB RAM): ~$10/month
- **ALB**: ~$20/month
- **NAT Gateway**: ~$35/month
- **Data Transfer**: Variable

**Total**: ~$80-100/month (varies with usage)

## Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## License

This project is provided as-is for educational purposes.

